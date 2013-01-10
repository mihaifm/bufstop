if exists('g:Bufstop_loaded') 
  finish
endif

let g:Bufstop_loaded = 1

let s:name = "--Bufstop--"
let s:lsoutput = ""
let s:types = ["fullname", "path", "shortname"]
let s:keystr = "1234asfcvzx5qwertyuiopbnm67890ABCEFGHIJKLMNOPQRSTUVZ"
let s:keys = split(s:keystr, '\zs')
let s:local_bufnr = -1
let s:fast_mode = 0

let g:Bufstop_history = []

function! s:SetProperties()
  setlocal nonumber
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal cursorline
  setlocal nospell
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nowrap

  if has("syntax")
    syn match bufstopKey /\v^\s\s(\d|\a|\s)/ contained
    syn match bufstopName /\v^\s\s(\d|\a|\s)\s+.+\s\s/ contains=bufstopKey
   
    hi def link bufstopKey String
    hi def link bufstopName Type
  endif
endfunction

function! s:BufStopSelectBuffer(k)
  let delkey = 0

  if (a:k == 'd')
    let delkey = 1
  endif

  let keyno = strridx(s:keystr, a:k) 
  let s:bufnr = -1

  if (keyno >= 0 && !delkey)
    for b in s:allbufs
      if b.key == a:k
        let s:bufnr = b.bufno
      endif
    endfor
    " move cursor on the selected line
    exe keyno+1
  else
    let s:bufnr = s:allbufs[line('.')-1].bufno
  endif

  if bufexists(s:bufnr)
    if delkey
      call remove(s:allbufs, line('.')-1)
      exe "silent bw ".s:bufnr
      setlocal modifiable
      exe "d"
      setlocal nomodifiable
    else
      exe "wincmd p"
      exe "keepalt keepjumps silent b" s:bufnr
      exe "wincmd p"
      if s:fast_mode
        exe "q"
        exe "wincmd p"
      endif
    endif
  endif
endfunction

function! s:MapKeys()
  nnoremap <buffer> <silent> <Esc>            :q<cr><C-w>p
  nnoremap <buffer> <silent> <cr>             :call <SID>BufStopSelectBuffer('cr')<cr>
  nnoremap <buffer> <silent> <2-LeftMouse>    :call <SID>BufStopSelectBuffer('cr')<cr>
  nnoremap <buffer> <silent> d                :call <SID>BufStopSelectBuffer('d')<cr>

  for buf in s:allbufs
    exe "nnoremap <buffer> <silent> ". buf.key. "   :call <SID>BufStopSelectBuffer('" . buf.key . "')<cr>"
  endfor
endfunction

function! s:GetBufferInfo()
  let s:allbufs = []
  let [s:allbufs, allwidths] = [[], {}]

  for n in s:types
    let allwidths[n] = []
  endfor
 
  let k = 0

  let bu_li = split(s:lsoutput, '\n')
  call sort(bu_li, "<SID>BufstopMRUCmp")

  for buf in bu_li
    let bits = split(buf, '"')
    let b = {"attributes": bits[0], "line": substitute(bits[2], '\s*', '', '')} 
    
    let b.path = bits[1]
    let b.fullname = bits[1]
    let pathbits = split(bits[1], '\\\|\/', 1)
    let b.shortname = pathbits[len(pathbits)-1]
    let b.bufno = str2nr(bits[0])

    if (k < len(s:keys))
      let b.key = s:keys[k]
    else
      let b.key = 'X'
    endif

    let k = k + 1

    call add(s:allbufs, b)

    for n in s:types
      call add(allwidths[n], len(b[n]))
    endfor
  endfor

  let s:allpads = {}

  for n in s:types
    let s:allpads[n] = repeat(' ', max(allwidths[n]))
  endfor

  return s:allbufs
endfunction

function! BufstopSlow()
  let s:fast_mode = 0
  call Bufstop()
endfunction

function!BufstopFast()
  let s:fast_mode = 1
  call Bufstop()
endfunction

function! Bufstop()
  let bufstop_winnr = bufwinnr(s:name)
  if bufstop_winnr != -1
    exe bufstop_winnr . "wincmd w"
    exe "q"
    return
  endif

  redir => s:lsoutput 
  exe "silent ls"
  redir END

  let lines = []
  let bufdata = s:GetBufferInfo()

  for buf in bufdata
    let line = ''
    if buf.key ==# 'X'
      let line = "  " . " " . "   "
    else
      let line = "  " . buf.key . "   "
    endif

    let path = buf["path"]
    let pad = s:allpads.shortname

    let line .= buf.shortname . "  " . strpart(pad . path, len(buf.shortname))
    
    call add(lines, line)
  endfor
  
  exe "botright " . min([len(lines), 20]) . " split"

  if s:local_bufnr < 0
    exe "silent e ".s:name
    let s:local_bufnr = bufnr(s:name)
  else
    exe "b ".s:local_bufnr
  endif
  
  setlocal modifiable
  exe 'setlocal statusline=Bufstop:\ ' . len(lines) . '\ buffers'
  " delete evertying in the buffer
  " (can't use 'normal ggdG' since the keys are remapped)
  exe 'goto'
  exe '%delete'
  call setline(1, lines)
  setlocal nomodifiable

  call s:SetProperties()

  call s:MapKeys()
endfunction

" Open the previous buffer in the navigation history for the current window.
function s:BufstopBack()
  if (!buflisted(winbufnr(winnr())))
    return
  endif

  if w:history_index > 0
    let w:history_index -= 1
    let bno = w:history[w:history_index]
    if (bufexists(bno) && buflisted(bno))
      execute "b " . bno
    else
      call map(w:history, 's:BufstopFilt(v:val, bno)')
      call s:BufstopBack()
    endif
  else
    " since we're here, do some cleanup
    call filter(w:history, 'v:val != -1')
    let w:history_index = 0
    call s:BufstopEcho("reached the bottom of window navigation history")
  endif
endfunction

" Open the next buffer in the navigation history for the current window.
function! s:BufstopForward()
  if (!buflisted(winbufnr(winnr())))
    return
  endif

  if w:history_index < len(w:history) - 1
    let w:history_index += 1
    let bno = w:history[w:history_index]
    if (bufexists(bno) && buflisted(bno))
      execute "b " . bno
    else
      call map(w:history, 's:BufstopFilt(v:val, bno)')
      call s:BufstopForward()
    endif
  else
    " since we're here, do some cleanup
    call filter(w:history, 'v:val != -1')
    let w:history_index = len(w:history) - 1
    call s:BufstopEcho("reached the top of window navigation history")
  endif
endfunction

" callback for map function
function! s:BufstopFilt(val, bufnr)
  if (a:val == a:bufnr)
    return -1
  endif

  return a:val
endfunction

" Add the buffer number to the navigation history for the window
function! s:BufstopAppend(bufnr)
    if !exists('w:history_index')
      let w:history_index = 0
      let w:history = []
    " ignore if the newly added buffer is the same as the previous active one
    elseif w:history[w:history_index] == a:bufnr
        return
    else
        let w:history_index += 1
    endif

    " replace the bufnr with -1 if it already exists
    call map(w:history, 's:BufstopFilt(v:val, a:bufnr)')

    let w:history = insert(w:history, a:bufnr, w:history_index)
endfunction

" Add the buffer number to the global navigation history 
function! s:BufstopGlobalAppend(bufnr)
  call filter(g:Bufstop_history, 'v:val != '.a:bufnr) 
  call insert(g:Bufstop_history, a:bufnr)
endfunction

" Echo a message in the Vim status line.
function! s:BufstopEcho(msg)
  echohl WarningMsg
  echomsg 'Bufstop: ' . a:msg
  echohl None
endfunction

function! s:BufstopMRUCmp(line1, line2)
  let i1 = index(g:Bufstop_history, str2nr(a:line1))
  let i2 = index(g:Bufstop_history, str2nr(a:line2))
  " make sure the buffers that are not in history end up at the bottom
  if i1 == -1
    let i1 = len(g:Bufstop_history) + 1
  endif
  if i2 == -1
    let i2 = len(g:Bufstop_history) + 1
  endif

  return  i1 - i2
endfunction

augroup Bufstop
  autocmd!
  autocmd BufEnter * :call s:BufstopAppend(winbufnr(winnr()))
  autocmd WinEnter * :call s:BufstopAppend(winbufnr(winnr()))
  autocmd BufWinEnter * :call s:BufstopGlobalAppend(expand('<abuf>') + 0)
augroup End


command! Bufstop :call BufstopSlow()
command! BufstopFast :call BufstopFast()
command! BufstopBack :call <SID>BufstopBack()
command! BufstopForward :call <SID>BufstopForward()
