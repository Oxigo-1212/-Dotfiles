// tmux-style prefix: ctrl-s opens this popup, the next key runs a command.
// Binds migrated from ~/.config/herdr/config.toml.
import { View, div } from "gpui-kit";
import { run, props, closeOverlay, theme, home } from "herdr";

const BINDS = {
  "|": ["pane.split", { direction: "right" }],
  "-": ["pane.split", { direction: "down" }],
  "n": ["tab.next", {}],
  "o": ["mod.open", { name: "picker-all" }],
  "O": ["agent.next", {}], // open_notification_target: closest app command
  "j": ["space.next", {}],
  "k": ["space.prev", {}],
  "down": ["pane.go", { direction: "down" }],
  "up": ["pane.go", { direction: "up" }],
  "p": ["pane.split", { direction: "down", argv: [`${home()}/.config/tmux/scripts/tmux-pdf-search.sh`] }],
  "ctrl-f": ["pane.split", { direction: "down", argv: [`${home()}/.config/herdr/scripts/sessionizer-app`] }],
};

export default class Prefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  render(cx) {
    const t = theme();
    return div()
      .id("prefix")
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        // GPUI spells ctrl as "cmd" on Linux; "|" arrives as shift-\, so prefer key_char for plain keys.
        const stroke = e.keystroke.replace(/^cmd-/, "ctrl-");
        const plain = !e.modifiers?.control && !e.modifiers?.platform && !e.modifiers?.alt;
        const bind = BINDS[plain && e.key_char ? e.key_char : stroke];
        if (["shift", "control", "alt", "platform"].includes(e.key)) return; // modifier alone: keep waiting
        closeOverlay(props().overlay);
        if (bind) run(bind[0], bind[1]);
        cx.stop_propagation();
      })
      .size_full().px(14).flex().items_center()
      .bg(t.popover).text_size(13).text_color(t.muted)
      .child("ctrl+s …  | - n o O j k ↑↓ p ^f   (Esc cancels)");
  }
}
