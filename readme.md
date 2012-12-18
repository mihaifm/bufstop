##Bufstop

Bufstop is a plugin for fast buffer switching, built for efficiency and less keystrokes.

Here is a **[short demo](http://www.youtube.com/watch?v=IwZSI-ZEoUY)** and 
**[screenshot](https://raw.github.com/mihaifm/bufstop/master/screen.png)**

**Bufstop** is a plugin for fast buffer switching, built for efficiency and less keystrokes.

It provides a `:Bufstop` command that opens a new window at the bottom of the 
screen containing the list of current buffers (ordered by most recently used).
Each buffer has an associated hotkey displayed besides it. When the hotkey is
pressed, the buffer is loaded in preview mode (it's opened in the most 
recent window without closing the **Bufstop** window).

Bufstop is more productive than using the native `:ls` and `:b` comamnds, since it can be used
to quickly preview opened files without closing the buffer list, and in general it requires 
less key strokes to open a buffer than other plugins.

The **Bufstop** window is easily dismissed with the `<Esc>` key.

This plugin also provides navigation history for each window. Use the 
`:BufstopForward` and `:BufstopBack` commands to quickly navigate the buffers
in the order they were opened.

Recommended `vimrc` mappings for these commands:
    
    map <leader>b :Bufstop<CR>
    map <C-tab>   :BufstopBack<CR>
    map <S-tab>   :BufstopForward<CR>


Usage
-----

This plugin provides the following commands:

    :Bufstop

Invokes the `Bufstop` window. Inside it, each buffer will have an associated 
hotkey that can be used to open the buffer. 

In addition, the following key mappings are present in the `Bufstop` window:

    d          wipe the selected buffer.
    <CR>       Open the selected buffer.
    <Esc>      Dismiss the Bufstop window
    k,j        Move up/down to select a buffer.
<br>

    :BufstopBack

Opens the previous buffer in the navigation history for the current window.

    :BufstopForward

Opens the next buffer in the navigation history for the current window.



