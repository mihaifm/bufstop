##Bufstop

Bufstop is a plugin for buffer switching, built for efficiency and less keystrokes.

It provides a single command, :Bufstop. When issued, it opens a new window
at the bottom of the screen, that contains the list of current buffers.
Each buffer has an associated hotkey displayed besides it. When the hotkey is
pressed, the buffer is loaded in the current window (the window that was
previously active before loading Bufstop).

Bufstop is more efficient than the native `:ls` comamnd, since it can be used
to quickly preview opened files without closing the buffer list.

The Bufstop window is easily dismissed with the `<Esc>` key.

Usage
-----

This plugin provides single command, that can be mapped to any desired key.

    :Bufstop

For example, you can use the followin mapping in your `vimrc`:

    map <leader>b :Bufstop<CR>

Inside the Bufstop window, each buffer will have an associated hotkey
that can be used to open the buffer. 

In addition, the following key mappings are present in the Bufstop window:

    d          wipe the selected buffer.
    <CR>       Open the selected buffer.
    <Esc>      Dismiss the Bufstop window
    k,j        Move up/down to select a buffer.



