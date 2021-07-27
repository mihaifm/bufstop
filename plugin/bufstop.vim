if exists('g:loaded_bufstop')
  finish
endif

let g:loaded_bufstop = 1

let g:Bufstop_name = "--Bufstop--"
let g:Bufstop_history = []

let s:frequency_map = {}

if has("syntax")
  hi def link bufstopKey String
  hi def link bufstopName Type
end

" callback for map function
function! s:BufstopFilt(val, bufnr)
  if (a:val == a:bufnr)
    return -1
  endif

  return a:val
endfunction

" add the buffer number to the navigation history for the window
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

" add the buffer number to the global navigation history
function! s:BufstopGlobalAppend(bufnr)
  if (!buflisted(a:bufnr))
    return
  endif
  call filter(g:Bufstop_history, 'v:val != '.a:bufnr)
  call insert(g:Bufstop_history, a:bufnr)

  if !has_key(s:frequency_map, a:bufnr)
    let s:frequency_map[a:bufnr] = 1
  else
    let s:frequency_map[a:bufnr] += 1
  endif
endfunction

function s:TimeoutFiddle(on_off)
  if a:on_off == 1
    let s:old_timeoutlen = &timeoutlen
    let &timeoutlen = 10
  else
    let &timeoutlen = s:old_timeoutlen
  end
endfunction

augroup Bufstop
  autocmd!
  autocmd BufEnter * :call s:BufstopAppend(winbufnr(winnr()))
  autocmd WinEnter * :call s:BufstopAppend(winbufnr(winnr()))
  autocmd BufWinEnter * :call s:BufstopGlobalAppend(expand('<abuf>') + 0)
  exe "autocmd BufWinEnter,WinEnter " . g:Bufstop_name . " :call s:TimeoutFiddle(1)"
  exe "autocmd BufWinLeave,WinLeave " . g:Bufstop_name . " :call s:TimeoutFiddle(0)"
augroup End

command! Bufstop :call bufstop#slow()
command! BufstopFast :call bufstop#fast()
command! BufstopPreview :call bufstop#preview()
command! BufstopSpeedToggle :call bufstop#speed_toggle()
command! BufstopBack :call bufstop#back()
command! BufstopForward :call bufstop#forward()
command! BufstopMode :call bufstop#mode_start()
command! BufstopModeFast :call bufstop#mode_fast_start()
command! BufstopStatusline :call bufstop#statusline()
command! BufstopStatuslineFast :call bufstop#statusline_fast()
