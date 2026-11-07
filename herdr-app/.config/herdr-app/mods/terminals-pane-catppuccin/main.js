// Terminals pane header; props: { pane, terminal }.

import { View, div, svg, image } from "gpui-kit";
import { h_flex } from "gpui-base";
import { panes, props, run, home, theme } from "herdr";


function folder(cwd) {
  if (!cwd) return "";
  const h = home();
  return cwd === h ? "~" : cwd.startsWith(h + "/") ? "~" + cwd.slice(h.length) : cwd;
}

export default class TerminalsPane extends View {
  me() {
    return panes().find((p) => p.pane === props()?.pane);
  }

  render() {
    const p = this.me();
    if (!p) return div();
    const pane = p.pane;
    const g = p.program;
    const where = folder(p.cwd);
    // Shells often put the folder in their title already.
    const title = p.title || "shell";
    const dir = where && !title.includes(where) && !/^[~/]/.test(title) ? where : "";
    return h_flex()
      .id(`tm-head-${pane}`)
      .size_full()
      .pl(12)
      .pr(8)
      .gap(8)
      .items_center()
      .text_size(12)
      .on_click(() => run("pane.focus", { pane }))
      .when(Boolean(g?.icon), (el) =>
        el.child(g.tint ? svg(g.icon).size(12).flex_none().text_color(theme().foreground) : image(g.icon).w(12).h(12).flex_none()),
      )
      .child(div().flex_none().max_w(320).truncate().text_color(p.focused ? theme().foreground : theme().muted).child(title))
      .child(div().flex_1().truncate().text_color(theme().dim).child(dir));
  }
}
