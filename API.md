# API reference

There is an Executor.pm module which creates parsers for any API or Hotkeys calls.
API is a simple text protocol over a TCP connection.
CRLF endings are also supported in order to use it via telnet(1).

Possible tokens:

- `<COLUMN NUM>` -- desired column
- `<DIRECTION>` -- any vimish direction: `h`, `j`, `k`, `l`
- `<FLOAT>` -- floating point number, dot is mandatory: `0.00`, `0.1`, `-3.145`
- `<FOCUS DIRECTION>` -- empty or `backward`
- `<ROW NUM>` -- desired row
- `<SCREEN NUM>` -- desired screen
- `<STRING>` -- any arbitrary UTF-8 string
- `<TAG NUM>` -- desired tag

Supported API functions are:

- Run shell command: `exec(<STRING>)`
- Set active tag: `tag_select(<TAG NUM>)`
- Close focused window: `win_close()`
- Window close or toggle floating / maximize / always\_on / pinned: `win_toggle_<floating|maximize|always_on|pinned>()`
- Open calendar: `toggle_calendar()`
- Move window to a particular tag: `win_move_tag(<TAG NUM>)`
- Set active screen: `screen_select(<SCREEN NUM>)`
- Move window to a particular screen: `win_move_screen(<SCREEN NUM>)`
- Focus previous window (screen independent): `focus_prev()`
- Cycle focus over the windows on current tag: `focus_cycle(<FOCUS DIRECTION>)`
- Focus move to a certain direction: `focus_move(<DIRECTION>)`
- Swap focused window with another one in a certain direction: `focus_swap(<DIRECTION>)`
- Resize the layout: `layout_resize(<DIRECTION>)`
- Show window selection dialog using Expose module: `expose()`
- Mark a window with some key: `mark_window()` -- reads next key to mark a window with
- Goto some window by a mark: `mark_switch_window()` -- reads next key to select a window by mark
- Resize the layout from API: `layout_resize(<SCREEN NUM>, <TAG NUM>, <ROW NUM>, <COLUMN NUM>, <FLOAT>, <FLOAT>)`
- Append windows from certain tag(s) to the active one: `tag_append(<TAG NUM>)`
- Make some window urgent by `WM_CLASS`: `urgent_by_class(<STRING>)`
- Exit from WM: `exit()`
- Do nothing: `nop()`, useful to null-route some keys

## Debug API

Several API calls are also available in case API debug mode is ON.
All of them will respond with the dump of certain data structures.

- `dump_windows()`
- `dump_screen(<SCREEN NUMBER>)`
- `dump_tag(<SCREEN NUMBER>, <TAG NUMBER>)`
