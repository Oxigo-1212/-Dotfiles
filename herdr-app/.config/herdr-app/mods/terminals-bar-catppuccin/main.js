// Terminals layout's draggable top bar: space picker, tabs, and window controls.
// Icons load from the shipped terminals-bar mod: this folder is a stow link and Herdr skips
// images whose real path is outside ~/.config/herdr-app.

import { View, div, svg, image } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, panes, run, theme, home, openOverlay, exec, nextCommand, settings, window as win } from "herdr";

// Add alpha to a #rrggbb theme color (the bar sits on a transparent layout).
const see = (c, a) => (/^#[0-9a-f]{6}$/i.test(c) ? c + a : c);
// Colors come from the theme so the bar follows the theme picker.
const C = {
  get tray() { return theme().chrome; },
  get tab() { return theme().surface; },
  get tabEdge() { return theme().input; },
  get hover() { return theme().hover; },
  get edge() { return theme().border; },
  get chip() { return theme().raised; },
  get text() { return theme().foreground; },
  get dim() { return theme().dim; },
};

function folder(cwd) {
  if (!cwd) return "";
  const h = home();
  return cwd === h ? "~" : cwd.startsWith(h + "/") ? "~" + cwd.slice(h.length) : cwd;
}

// The pane a tab's tab speaks for: the focused one, else its agent, else the first.
function lead(all, id) {
  const mine = all.filter((p) => p.tab === id);
  return mine.find((p) => p.focused) ?? mine.find((p) => p.program?.agent) ?? mine[0];
}

// The program's tile from the app's table: its color, its glyph (or logo) on it.
function tile(t, p, k = 1) {
  const g = p?.program;
  const dot = p?.status && p.status !== "idle" ? t[p.status] : null;
  return div()
    .relative()
    .flex_none()
    .w(20 * k)
    .h(18 * k)
    .rounded(6 * k)
    .border_1()
    .border_color(see(C.tabEdge, "4d"))
    .bg(g?.tile ?? C.chip)
    .flex()
    .items_center()
    .justify_center()
    .when(Boolean(g?.icon), (el) =>
      el.child(g.tint ? svg(g.icon).size(12 * k).text_color(g.color ?? C.text) : image(g.icon).w(12 * k).h(12 * k)),
    )
    .when(Boolean(dot), (el) =>
      el.child(div().absolute().top(-3).right(-3).w(7).h(7).rounded_full().border_1().border_color(C.tray).bg(dot)),
    );
}

// A control in the draggable bar: the press is its own, not the window's
// (a right press there would open the system's window menu).
function own(el) {
  return el.on_mouse_down("left", (_e, cx) => cx.stop_propagation()).on_mouse_down("right", (_e, cx) => cx.stop_propagation());
}


function iconButton(id, icon, onClick) {
  return own(div())
    .id(id)
    .flex_none()
    .p(5)
    .rounded(7)
    .text_color(C.dim)
    .cursor_pointer()
    .hover((s) => s.bg(C.chip).text_color(C.text))
    .on_click(onClick)
    .child(svg(`mods/terminals-bar/${icon}.svg`).size(13));
}

// One folder's git, from one `git status`: { branch, ahead, behind, changes, linked }; null outside git.
async function gitInfo(cwd, on) {
  const opts = { cwd, on };
  const r = await exec("git", ["--no-optional-locks", "-c", "core.fsmonitor=false", "status", "--porcelain=v2", "--branch"], opts);
  if (r.code !== 0) return null;
  const lines = r.stdout.split("\n");
  const head = lines.find((l) => l.startsWith("# branch.head "))?.slice(14);
  const ab = lines.find((l) => l.startsWith("# branch.ab "))?.match(/\+(\d+) -(\d+)/);
  const changes = lines.filter((l) => l && !l.startsWith("#")).length;
  const d = await exec("git", ["rev-parse", "--git-dir", "--git-common-dir"], opts);
  const [dir, common] = d.stdout.trim().split("\n");
  return { branch: head === "(detached)" ? "detached" : head, ahead: Number(ab?.[1] ?? 0), behind: Number(ab?.[2] ?? 0), changes, linked: dir !== common };
}

// The space menu, under the space button. Height: field + one row per space (at most 10) + divider + 2 actions.
const openPicker = () => {
  const n = Math.min(spaces().length, 10) || 1;
  openOverlay({ mod: "space-menu", kind: "popup", at: { x: 8, y: 40 }, width: 300, height: 12 + 34 + n * 32 + 9 + 2 * 32 });
};

export default class TerminalsBar extends View {
  init(_props, cx) {
    this.gitAt = {}; // folder -> its git info, so switching back to a tab shows it at once
    this.cwd = null;
    cx.timer.every(4000, (cx) => this.refresh(cx));
    // keys.json: "<key>": "terminals-bar-catppuccin.goto" opens the space menu under the space button.
    // "terminals-bar-catppuccin.open": the folder-open dialog (new space in a chosen folder).
    cx.spawn(async (cx) => { for (;;) { const c = await nextCommand(); if (c === "goto") openPicker(); else if (c === "open") openOverlay({ mod: "folder-open", kind: "dialog", width: 560, height: 520 }); } });
  }

  // Re-read the shown tab's folder now (called on a tab switch and every 4s).
  refresh(cx) {
    const sp = spaces().find((p) => p.active);
    const cwd = sp && lead(panes(), sp.tabs.find((c) => c.active)?.id)?.cwd;
    if (!cwd) return;
    cx.spawn(async (cx) => {
      try { this.gitAt[cwd] = await gitInfo(cwd, sp.machine ?? undefined); } catch { this.gitAt[cwd] = null; }
      cx.notify();
    });
  }

  render(cx) {
    const t = theme();
    const space = spaces().find((p) => p.active);
    if (!space) return div();
    // New tabs start collapsed and grow in; tabs present at startup don't animate.
    const first = !this.seen;
    this.seen ??= new Set();
    const fresh = space.tabs.filter((c) => !this.seen.has(c.id)).map((c) => c.id);
    fresh.forEach((id) => this.seen.add(id));
    if (first) fresh.length = 0;
    else if (fresh.length) {
      this.growing = new Set(fresh);
      cx.timer.after(16, (c) => { this.growing = null; c.notify(); });
    }
    const all = panes();
    const cwd = lead(all, space.tabs.find((c) => c.active)?.id)?.cwd ?? null;
    if (cwd !== this.cwd) { this.cwd = cwd; this.refresh(cx); }
    this.git = cwd ? this.gitAt[cwd] : null;
    const w = win() ?? {};
    // Scale everything with the bar's height (designed at 30px), so dragging its edge resizes the contents.
    const k = Math.max(0.6, (this.size?.height ?? 30) / (30 * (settings().zoom ?? 1))); // size comes in zoomed px

    const tabs = space.tabs;
    const tab = (c, i) => {
      const p = lead(all, c.id);
      const where = folder(p?.cwd);
      const label = where && !c.named ? `${where}> ${c.name}` : c.name;
      const grow = this.growing?.has(c.id);
                  return own(h_flex())
        .id(`tm-${c.id}`)
        .flex_1()
        .min_w(0)
        .max_w(grow ? 0 : 220 * k)
        .opacity(grow ? 0 : 1)
        .transition("opacity", { duration: 220, easing: "ease-out" })
        .h(24 * k)
        .pl(6 * k)
        .pr(10 * k)
        .gap(8 * k)
        .items_center()
        .rounded(9 * k)
        .border_1()
        .cursor_pointer()
        .text_size(12 * k)
        .when(c.active, (el) => el.bg(see(C.tray, "8c")).border_color(see(C.edge, "40")))
        .when(!c.active, (el) => el.border_color("#00000000").hover((s) => s.bg(see(C.tray, "4d"))))
        .on_click((e) => run(e.click_count === 2 ? "tab.rename" : "tab.select", { id: c.id }))
        .on_mouse_down("right", () =>
          openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: c.id, space: space.id } } }),
        )
        .child(tile(t, p, k))
        .child(div().flex_1().min_w(0).truncate().text_color(c.active ? C.text : C.dim).child(label))
        // The close button shows only while the pointer is on this tab.
        .on_hover((on, cx) => { if (on) this.hovered = c.id; else if (this.hovered === c.id) this.hovered = null; cx.notify(); })
        .when(this.hovered === c.id, (el) => el.child(own(div()).id(`tm-x-${c.id}`).flex_none().px(4).rounded(4).text_color(C.dim)
          .hover((s) => s.bg(C.hover).text_color(C.text)).on_click((_e, cx) => { cx.stop_propagation(); run("tab.close", { id: c.id }); }).child("\u00d7")));
    };

    return h_flex()
      .id("root")
      .on_size_change((size, cx) => { if (size.height !== this.size?.height) { this.size = size; cx.notify(); } })
      .size_full()
      .px(4)
      .gap(6)
      .items_center()
      .when(w.platform === "macos" && w.titlebar === "none" && !w.fullscreen, (el) => el.pl(72))
      .child(
        own(div())
          .id("tm-space")
          .flex_none()
          .h(24 * k)
          .px(8 * k)
          .gap(6 * k)
          .flex()
          .items_center()
          .rounded(9 * k)
          .cursor_pointer()
          .text_size(12 * k)
          .text_color(C.dim)
          .hover((s) => s.bg(see(C.tray, "4d")).text_color(C.text))
          .on_click(openPicker)
          .child(svg("mods/terminals-bar/stack.svg").size(13 * k))
          .child(div().text_color(C.text).child(space.name))
          .when(Boolean(this.git), (el) => {
            const g = this.git;
            return el
              .child(div().child(`${g.linked ? "\u2387 worktree " : "\u2387 "}${g.branch}`))
              .when(g.ahead > 0, (el) => el.child(div().text_color(t.done).child(`\u2191${g.ahead}`)))
              .when(g.behind > 0, (el) => el.child(div().text_color(t.blocked).child(`\u2193${g.behind}`)))
              .when(g.changes > 0, (el) => el.child(div().text_color(t.working).child(`\u25cf${g.changes}`)));
          }),
      )
      .child(h_flex().flex_1().min_w(0).h(26 * k).px(1).gap(6 * k).items_center().children(tabs.map(tab)))
  }
}
