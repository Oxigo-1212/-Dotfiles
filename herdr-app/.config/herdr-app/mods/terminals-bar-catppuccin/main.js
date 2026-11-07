// Terminals layout's draggable top bar: space picker, tabs, and window controls.

import { View, div, svg, image } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, panes, run, theme, home, openOverlay, window as win } from "herdr";

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
function tile(t, p) {
  const g = p?.program;
  const dot = p?.status && p.status !== "idle" ? t[p.status] : null;
  return div()
    .relative()
    .flex_none()
    .w(18)
    .h(16)
    .rounded(4)
    .bg(g?.tile ?? C.chip)
    .flex()
    .items_center()
    .justify_center()
    .when(Boolean(g?.icon), (el) =>
      el.child(g.tint ? svg(g.icon).size(11).text_color(g.color ?? C.text) : image(g.icon).w(11).h(11)),
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
    .child(svg(`mods/terminals-bar-catppuccin/${icon}.svg`).size(13));
}

export default class TerminalsBar extends View {
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
    const w = win() ?? {};

    const tabs = space.tabs;
    const at = tabs.findIndex((c) => c.active);
    const tab = (c, i) => {
      const p = lead(all, c.id);
      const where = folder(p?.cwd);
      const label = where ? `${where}> ${c.name}` : c.name;
      const grow = this.growing?.has(c.id);
      // A thin divider between two inactive tabs, like a native tab strip.
      const divider = i > 0 && i !== at && i - 1 !== at;
      return own(h_flex())
        .id(`tm-${c.id}`)
        .flex_shrink(1)
        .min_w(0)
        .w(grow ? 0 : 175)
        .opacity(grow ? 0 : 1)
        .transition("width", { duration: 220, easing: "ease-out" })
        .transition("opacity", { duration: 220, easing: "ease-out" })
        .h_full()
        .px(8)
        .gap(6)
        .items_center()
        .rounded(7)
        .cursor_pointer()
        .text_size(12)
        .when(divider, (el) => el.border_l_1().border_color(C.edge).rounded(0))
        .when(c.active, (el) => el.bg(C.tab).border_1().border_color(C.tabEdge))
        .when(!c.active, (el) => el.hover((s) => s.bg(C.hover)))
        .on_click(() => run("tab.select", { id: c.id }))
        .on_mouse_down("right", () =>
          openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: c.id, space: space.id } } }),
        )
        .child(tile(t, p))
        .child(div().min_w(0).truncate().text_color(c.active ? C.text : C.dim).child(label));
    };

    return h_flex()
      .size_full()
      .px(4)
      .gap(6)
      .items_center()
      .when(w.platform === "macos" && w.titlebar === "none" && !w.fullscreen, (el) => el.pl(72))
      .child(
        own(div())
          .id("tm-space")
          .flex_none()
          .p(5)
          .rounded(7)
          .cursor_pointer()
          .text_color(C.dim)
          .hover((s) => s.bg(C.hover).text_color(C.text))
          .on_click(() => openOverlay({ mod: "picker-all", kind: "popup", at: "top", offset: 40, width: 640, height: 0.8 }))
          .child(svg("mods/terminals-bar-catppuccin/stack.svg").size(13)),
      )
      .child(h_flex().flex_1().min_w(0).h(22).gap(2).items_center().children(tabs.map(tab)))
      .child(iconButton("tm-new", "plus", () => run("tab.new", { space: space.id })));
  }
}
