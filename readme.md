# Bufstop

If you find yourself frequently switching back and forth between files, and looking for 
a faster way to do it, well...your journey has come to an end. Welcome to the **Bufstop** !

**Bufstop** is a plugin for faster buffer switching, built for efficiency and less keystrokes.
It provides no less than 7 ways to display and switch buffers.

If you can think of faster ways to switch files, let me know and I will include them in the plugin.

![screenshot1](https://cloud.githubusercontent.com/assets/981184/3208138/651a0f36-ee1c-11e3-9a40-5191fdcab2df.png)

![screenshot2](https://cloud.githubusercontent.com/assets/981184/3208142/0306711c-ee1d-11e3-9121-0bfad5d43909.png)

## Buffer window with hotkeys

The `:Bufstop` command opens a new window at the top/bottom of the screen containing the list of
current buffers, ordered by most recently used. Each buffer has an associated hotkey 
displayed besides it. When pressed, the correspoding buffer
is loaded, with the focus remaining in the Bufstop window. This way you can quickly preview
buffers with only 1 keystroke !

The Bufstop window is easily dismissed with the `<Esc>` key.

There is also a `:BufstopFast` command which opens the Bufstop window in the same way,
but spares you the effort of pressing the `<Esc>` key : the window closes automatically after
you select a buffer.

**_Tip:_** If you're using the recommended mappings (see below), `<leader>b2` will always take you to
the previously opened file (aka *alternate buffer*)

## Preview mode

The `:BufstopPreview` command is similar to the `:Bufstop` command, with the notable difference that you can
preview and navigate files by moving **up or down** in the window with `j,k` or arrow keys. 
It is a powerful and instant way to check your files.

**_Tip:_** You can still switch files by pressing the hotkeys associated with them.

## Minimal mode inside the command line

Don't like a pottentially huge file list popping on the screen? Use the `:BufstopMode` command.
Buffers will be displayed in the command line, in the same order: by most recently used.

In this mode, you can only press numbers. Pressing `3` will take you to the 3rd recently used 
buffer. However here's __*the catch*__: because the 3rd buffer will now be first in the hierarchy,
it's place will be taken by another buffer.   
So pressing `33333....` will __*cycle between the last 3 buffers*__.   
Similarly, `4444` will cycle the last 4 buffers, and so on.

Pressing `<Esc>` will dismiss the mode. There is a `:BufstopModeFast` alternative, 
which dismisses the mode once you select a buffer.

**_Tip:_** The first buffer labeled with `1` will always be the current file.

## On the statusline

The `:BufstopStatusline` command works the same way as `:BufstopMode`, but displays the buffers
on the statusline. As before, there is a fast alternative, `:BufstopStatuslineFast` that
will close the mode once you select something.

**_Tip:_** No worries, your old statusline is restored once you exit the mode.

## Extreme speed hotkeys

The previous methods are cool, but they still require a mapping to bring up the buffer list
(typically `<leader>b`).    
Looking for a faster way? Use the `:BufstopSpeedToggle` command. 

It creates the following mappings: `<leader>2` opens the previous buffer, `<leader>3` to open
the 3rd recently used buffer, and so on.

Using `:BufstopSpeedToggle` again will clear out these mappings.

**_Tip:_** Pressing `,5,5,5...` will cycle the last 5 buffers.

## Ultimate

The previous speed method requires 2 keys to open any arbitrary buffer. Too much? Put this 
in your `vimrc`:

    let g:BufstopSpeedKeys = ["<F1>", "<F2>", "<F3>", "<F4>", "<F5>", "<F6>"]
    let g:BufstopLeader = ""
    let g:BufstopAutoSpeedToggle = 1

Yes, you guessed it. __*1 key to open arbitrary buffers*__ !

Once again, pressing `<F4><F4><F4>...` will cycle between the last 4 buffers.

**_Tip:_** Already had something mapped to `<Fx>`? Use `:BufstopSpeedToggle` to switch off
these mappings. Bufstop will attempt to restore your old mapping (given that you didn't use
`noremap`).

## Bonuses

1. As a bonus, this plugin provides __*navigation history for each window*__.    
Use the `:BufstopBack` and `:BufstopForward` to navigate this history.

2. The other bonus is the ability to sort the buffers by __*MFU (most frequently
used)*__. Use the `g:BufstopSorting` option to activate this powerful feature.

## Recommended mappings

Hopefully we're not crazy to type in those long command names. You can use the below 
mappings or create your own:

    map <leader>b :Bufstop<CR>             " get a visual on the buffers
    map <leader>w :BufstopPreview<CR>      " switch files by moving inside the window
    map <leader>a :BufstopModeFast<CR>     " a command for quick switching
    map <C-tab>   :BufstopBack<CR>
    map <S-tab>   :BufstopForward<CR>
    let g:BufstopAutoSpeedToggle = 1       " now I can press ,3,3,3 to cycle the last 3 buffers

## Don't like this plugin?

At least put this in your `vimrc`:

    :map <leader>b :ls<CR>:b

It will display the buffer list and prompt you for a number. Simple, but primitive, especially 
when you're dealing with a lot of files.

In addition to this plugin, you can use a fuzzy finder like 
[CtrlP](https://github.com/kien/ctrlp.vim), which requires you to type parts of the file name.

## Reference documentation

### Commands:

* `:Bufstop`  

Invokes the `Bufstop` window. Inside it, each buffer will have an associated 
hotkey that can be used to open the buffer. 

In addition, the following key mappings are present in the `Bufstop` window:

    d          Wipe the selected buffer (close the file)
    <CR>       Open the selected buffer.
    <Esc>      Dismiss the Bufstop window
    k,j        Move up/down to select a buffer.

* `:BufstopFast`   

Same as `:Bufstop`, but the window is closed after you select a buffer.    

* `:BufstopPreview`   

Same as `:Bufstop` but navigating to different rows with k,j or arrow keys will
instantly swtich buffers.

* `:BufstopMode`

Display the most recently used buffers in the command line and enter Bufstop mode.
In this mode you can press only a number coresponding to a buffer, or the `<Esc>` key
which exits the mode. The number of displayed files can be configured using
the `g:BufstopModeNumFiles` option.

* `:BufstopModeFast`

Same as `:BufstopMode` but exits the mode once a buffer is selected.

* `:BufstopStatusline`

Same as `:BufstopMode` but displays the list in the statusline. The old statusline is 
restored once the mode is dismissed.

* `:BufstopStatuslineFast`

Same as `:BufstopStatusline` but exists the mode once a buffer is selected.

* `:BufstopSpeedToggle`

Toggle speed mappings. The defaults are `<leader>2` to go to the 2nd recently used buffer,
`<leader>3` to go to the 3rd, an so on. These can be configured using the
`g:BufstopSpeedKeys` and `g:BufstopLeader` options.

* `:BufstopBack`

Opens the previous buffer in the navigation history for the current window.

* `:BufstopForward`

Opens the next buffer in the navigation history for the current window.

## Config

* `g:BufstopKeys`

The shortcut keys used to switch buffers. The keys are displayed next to the
buffer names, in the order they appear in this string.
Default: `"1234asfcvzx5qwertyuiopbnm67890ABCEFGHIJKLMNOPQRSTUVZ"`

* `g:BufstopSpeedKeys`

Keys used to create speed mappings. The `g:BufstopLeader` will be appended to
each key to create the mappig.
Default: `["1", "2", "3", "4", "5", "6"]`

* `g:BufstopLeader`

The key that is appended to the speed mappings. 
Default: `"<leader>"`

* `g:BufstopAutoSpeedToggle`

Mount the speed mappings automatically when loading the plugin. Default is 0.

* `g:BufstopSplit`

The split location of the Bufstop window. Valid options are the ones that
influence the `:split` command in Vim: `topleft`, `leftabove`, `rigthbelow`, etc.
Default: `"botright"`

* `g:BufstopSorting`

Controls the way buffers are sorted before being displayed. Valid options are:

    "MRU" - sort by most recently used
    "MFU" - sort by most frequently used
    "none" or "" - disable sorting

Default: `"MRU"`

More config options with `:help Bufstop`

Enjoy!
