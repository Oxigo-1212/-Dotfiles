#!/bin/bash

DOCUMENTS_DIR="$HOME/Documents"

PDF_FILE=$(find "$DOCUMENTS_DIR" -type f -name "*.pdf" 2>/dev/null | sed "s|$DOCUMENTS_DIR/||" |
  fzf --prompt="Select PDF: " \
    --height=40% \
    --border \
    --preview="echo {}" \
    --preview-window=up:1)

if [ -n "$PDF_FILE" ]; then
  setsid -f zathura "$DOCUMENTS_DIR/$PDF_FILE" </dev/null >/dev/null 2>&1
fi
