// Choose a folder, open it as a new space. Type to filter, ↑/↓ to move,
// Enter goes into the folder (on "Open here": opens it), ctrl+Enter opens
// the selected folder, Backspace on an empty filter goes up, Esc leaves.

import { View, div, svg } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { run, exec, home, theme, props, closeOverlay } from "herdr";

const SHOWN = 12; // ponytail: no scrolling; type to narrow long folders

export default class FolderOpen extends View {
  init(_props, cx) {
    this.input = InputState.new({ placeholder: "Filter folders…" });
    this.input.on("change", (_e, cx) => { this.at = 0; cx.notify(); });
    this.input.on("submit", (_e, cx) => this.enter(cx, false));
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.handle = cx.focus_handle();
    this.go(home(), cx);
  }

  go(path, cx) {
    this.path = path.replace(/(.)\/$/, "$1");
    this.dirs = [];
    this.at = 0;
    this.input.set_value("");
    cx.spawn(async (cx) => {
      const r = await exec("find", [this.path, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-printf", "%f\n"]).catch(() => null);
      this.dirs = (r?.stdout ?? "").split("\n").filter(Boolean).sort((a, b) => (a[0] === ".") - (b[0] === ".") || a.localeCompare(b));
      cx.notify();
    });
    cx.notify();
  }

  rows() {
    const f = (this.input.value() ?? "").toLowerCase();
    const dirs = this.dirs.filter((d) => (f ? d.toLowerCase().includes(f) : d[0] !== "."));
    return [{ here: true }, ...dirs.map((name) => ({ name }))];
  }

  join(name) { return this.path === "/" ? `/${name}` : `${this.path}/${name}`; }

  open(path) {
    closeOverlay(props().overlay);
    run("space.new", { folder: path });
  }

  enter(cx, openIt) {
    const r = this.rows()[this.at];
    if (!r || r.here) return this.open(this.path);
    if (openIt) return this.open(this.join(r.name));
    this.go(this.join(r.name), cx);
  }

  render() {
    const t = theme();
    const rows = this.rows();
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));
    const start = Math.max(0, Math.min(this.at - SHOWN + 1, rows.length - SHOWN));
    const shown = rows.slice(start, start + SHOWN);
    const short = this.path.startsWith(home()) ? "~" + this.path.slice(home().length) : this.path;

    return v_flex()
      .id("folder-open")
      .track_focus(this.handle)
      .size_full()
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((e, cx) => {
        const k = e.key, n = rows.length;
        if (k === "escape") return closeOverlay(props().overlay);
        if (k === "down") this.at = (this.at + 1) % n;
        else if (k === "up") this.at = (this.at + n - 1) % n;
        else if (k === "enter" && e.modifiers.control) return this.enter(cx, true);
        else if (k === "backspace" && !this.input.value() && this.path !== "/") this.go(this.path.replace(/\/[^/]*$/, "") || "/", cx);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(h_flex().items_center().child(div().flex_1().truncate().text_size(15).font_semibold().text_color(t.foreground).child(short)).child(div().text_size(11).text_color(t.dim).child("⌫ up · ⏎ in · ^⏎ open")))
      .child(
        h_flex().h(36).flex_none().px(10).gap(8).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
          .child(svg("mods/workspace-chrome/search.svg").size(15).text_color(t.dim))
          .child(Input.new(this.input).flex_1().h_full().text_size(12.8).text_color(t.foreground)),
      )
      .child(
        v_flex().flex_1().min_h(0).overflow_hidden().children(shown.map((r, j) => {
          const i = start + j, on = i === this.at;
          return h_flex()
            .id(`fo-${i}`)
            .flex_none().h(30).px(10).gap(10).rounded(7).items_center().cursor_pointer()
            .when(on, (el) => el.bg(t.hover))
            .hover((s) => s.bg(t.hover))
            .on_click((_e, cx) => (r.here ? this.open(this.path) : this.go(this.join(r.name), cx)))
            .child(div().w(14).flex_none().text_color(r.here ? t.accent : t.dim).child(r.here ? "＋" : "▸"))
            .child(div().flex_1().truncate().text_color(t.foreground).when(r.here, (d) => d.font_semibold()).child(r.here ? "Open here as new space" : r.name));
        })),
      );
  }
}
