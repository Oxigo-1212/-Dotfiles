// Space menu: a small popup under the bar's space button.
// Type to filter spaces; Enter goes to the highlighted one, or makes a space
// with that name when nothing matches. Then "New space" and "Add remote host…".

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { spaces, run, theme, props, closeOverlay } from "herdr";

export default class SpaceMenu extends View {
  init(_props, cx) {
    this.text = "";
    this.at = 0;
    this.input = InputState.new({ placeholder: "Filter or create…" });
    this.input.on("change", (_e, cx) => { this.text = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", () => this.choose(this.rows()[this.at]));
    this.input.focus();
    cx.timer.after(100, () => this.input.focus());
  }

  // The rows in order: matching spaces, then the actions. Enter on "create" makes a named space.
  rows() {
    const f = this.text.trim().toLowerCase();
    // pos: its place in the full list, 1-based, which is what alt-N (space.select:N) uses.
    const list = spaces().map((s, i) => ({ space: s, pos: i + 1 })).filter((r) => !f || r.space.name.toLowerCase().includes(f));
    if (f && list.length === 0) list.push({ create: this.text.trim() });
    return [...list, { action: "new" }, { action: "remote" }];
  }

  close() {
    closeOverlay(props()?.overlay);
  }

  choose(r) {
    if (!r) return;
    this.close();
    if (r.space) run("space.select", { id: r.space.id });
    else if (r.create) run("space.new", { name: r.create });
    else if (r.action === "new") run("space.new", {});
    else run("app.settings", { section: "machines" });
  }

  key(e, cx) {
    const n = this.rows().length;
    if (e.key === "escape") return this.close();
    if (e.key === "down") this.at = (this.at + 1) % n;
    else if (e.key === "up") this.at = (this.at + n - 1) % n;
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  render() {
    const t = theme();
    const rows = this.rows();
    const firstAction = rows.findIndex((r) => r.action);
    const row = (r, i) => {
      const on = i === this.at;
      const label = r.space ? r.space.name : r.create ? `Create "${r.create}"` : r.action === "new" ? "New space" : "Add remote host…";
      const hint = r.space && r.pos <= 9 ? `alt-${r.pos}` : r.action === "new" ? "ctrl-shift-n" : "";
      return h_flex()
        .id(`sm-${i}`)
        .h(30)
        .px(8)
        .gap(8)
        .items_center()
        .rounded(6)
        .cursor_pointer()
        .when(on, (el) => el.bg(t.accent).text_color(t.accent_foreground))
        .when(!on, (el) => el.text_color(t.foreground).hover((s) => s.bg(t.hover)))
        .on_click(() => this.choose(r))
        .child(div().w(14).flex_none().child(r.space?.active ? "✓" : r.action === "new" ? "+" : r.action === "remote" ? "☁" : ""))
        .child(div().flex_1().min_w(0).truncate().child(label))
        .child(div().flex_none().text_size(11).text_color(on ? t.accent_foreground : t.dim).child(hint));
    };
    return v_flex()
      .id("space-menu")
      .on_key_down((e, cx) => this.key(e, cx))
      .size_full()
      .p(6)
      .gap(2)
      .bg(t.popover)
      .text_size(13)
      .child(Input.new(this.input).h(30).px(8).mb(4).items_center().rounded(6).border(1).border_color(t.input).bg(t.background).text_color(t.foreground))
      .children(rows.slice(0, firstAction).map(row))
      .child(div().h(1).my(4).bg(t.border))
      .children(rows.slice(firstAction).map((r, j) => row(r, firstAction + j)));
  }
}
