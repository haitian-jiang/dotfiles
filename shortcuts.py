# ~/.ipython/profile_default/startup/keybindings.py

from prompt_toolkit.key_binding import KeyBindings, merge_key_bindings
from prompt_toolkit.key_binding.bindings import named_commands as nc
from prompt_toolkit.keys import Keys
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import has_focus, has_selection, emacs_insert_mode
from IPython import get_ipython

ipython = get_ipython()
if getattr(ipython, "pt_app", None):
    kb = KeyBindings()

    # Ctrl-W → backward_kill_word
    @kb.add(
        Keys.ControlW,
        filter=(has_focus(DEFAULT_BUFFER) & ~has_selection & emacs_insert_mode),
    )
    def _(event):
        return nc.backward_kill_word(event)

    # Shift-Left → backward_word_space
    def backward_word_space(event):
        buf = event.current_buffer
        pos = buf.document.find_previous_word_beginning(count=event.arg, WORD=True)
        if pos:
            buf.cursor_position += pos

    @kb.add(Keys.ShiftLeft, filter=(has_focus(DEFAULT_BUFFER) & emacs_insert_mode))
    def _(event):
        return backward_word_space(event)

    # Shift-Right → forward_word_space
    def forward_word_space(event):
        buf = event.current_buffer
        pos = buf.document.find_next_word_ending(count=event.arg, WORD=True)
        if pos:
            buf.cursor_position += pos

    @kb.add(Keys.ShiftRight, filter=(has_focus(DEFAULT_BUFFER) & emacs_insert_mode))
    def _(event):
        return forward_word_space(event)

    # ; → 接受 autosuggest，否则输入 ;
    @kb.add(";")
    def _(event):
        buf = event.app.current_buffer
        if buf.suggestion:
            buf.insert_text(buf.suggestion.text)  # accept autosuggestion
        else:
            buf.insert_text(";")

    # 合并到 IPython 的 key_bindings
    ipython.pt_app.key_bindings = merge_key_bindings(
        [
            ipython.pt_app.key_bindings,
            kb,
        ]
    )
