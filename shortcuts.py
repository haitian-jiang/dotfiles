from prompt_toolkit.key_binding.bindings import named_commands as nc
from prompt_toolkit.keys import Keys
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import has_focus, has_selection, emacs_insert_mode

ipython = get_ipython()

def backward_word_space(event):
    buf = event.current_buffer
    pos = buf.document.find_previous_word_beginning(count=event.arg, WORD=True)

    if pos:
        buf.cursor_position += pos


def forward_word_space(event):
    buf = event.current_buffer
    pos = buf.document.find_next_word_ending(count=event.arg, WORD=True)

    if pos:
        buf.cursor_position += pos


if getattr(ipython, 'pt_app', None):
    registry = ipython.pt_app.key_bindings

    registry.add_binding(Keys.ControlW,
                         filter=(has_focus(DEFAULT_BUFFER)
                                 & ~has_selection
                                 & emacs_insert_mode))(nc.backward_kill_word)
    registry.add_binding(Keys.ShiftLeft,
                         filter=(has_focus(DEFAULT_BUFFER)
                                 & emacs_insert_mode))(backward_word_space)
    registry.add_binding(Keys.ShiftRight,
                         filter=(has_focus(DEFAULT_BUFFER)
                                 & emacs_insert_mode))(forward_word_space)
