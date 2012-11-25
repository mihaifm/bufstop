if exists('g:Bufstop_loaded') 
  finish
endif

let g:Bufstop_loaded = 1

let s:name = "--Bufstop--"
let s:lsoutput = ""
let s:types = {"fullname": ':p', "path": ':p:h', "shortname": ':t'}
let s:keystr = "1234asfcvzx5qwertyuiopbnm67890ABCEFGHIJKLMNOPQRSTUVXZ"
let s:keys = split(s:keystr, '\zs')
let s:local_bufnr = -1

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
    syn match bufstopBufKey /\v^\s*(\d|\a)/ contained
    syn match bufstopBufName /\v^\s*(\d|\a)\s+.+\s\s/ contains=bufstopBufKey
   
    hi def link bufstopBufKey String
    hi def link bufstopBufName Type
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
      exec "keepalt keepjumps silent b" s:bufnr
      exe "wincmd p"
    endif
  endif
endfunction

function! s:MapKeys()
  nnoremap <buffer> <silent> <Esc>   :q<cr><C-w>p
  nnoremap <buffer> <silent> <cr>    :call <SID>BufStopSelectBuffer('cr')<cr>
  nnoremap <buffer> <silent> d       :call <SID>BufStopSelectBuffer('d')<cr>

  for buf in s:allbufs
    exe "nnoremap <buffer> <silent> ". buf.key. "   :call <SID>BufStopSelectBuffer('" . buf.key . "')<cr>"
  endfor
endfunction

function! s:GetBufferInfo()
  let s:allbufs = []
  let [s:allbufs, allwidths] = [[], {}]

  for n in keys(s:types)
    let allwidths[n] = []
  endfor
 
  let k = 0

  for buf in split(s:lsoutput, '\n')
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

    for n in keys(s:types)
      call add(allwidths[n], len(b[n]))
    endfor
  endfor

  let [s:allpads] = [{}]

  for n in keys(s:types)
    let s:allpads[n] = repeat(' ', max(allwidths[n]))
  endfor

  return s:allbufs
endfunction

function! Bufstop()
  redir => s:lsoutput 
  exe "silent ls"
  redir END

  let lines = []
  let bufdata = s:GetBufferInfo()

  for buf in bufdata
    let line = "  " . buf.key . "   "

    let path = buf["path"]
    let pad = s:allpads.shortname

    let line .= buf.shortname."  ".strpart(pad.path, len(buf.shortname))
    
    call add(lines, line)
  endfor
  
  exe "botright " . len(lines) . " split"

  if s:local_bufnr < 0
    exe "silent e ".s:name
    let s:local_bufnr = bufnr(s:name)
  else
    exe "b ".s:local_bufnr
  endif
  
  setlocal modifiable
  call setline(1, lines)
  setlocal nomodifiable

  call s:SetProperties()

  call s:MapKeys()
endfunction

command! Bufstop :call Bufstop()
