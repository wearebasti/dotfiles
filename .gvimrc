set background=light
colorscheme solarized
set columns=95

" thank you: https://stackoverflow.com/questions/7955473/smart-window-resizing-with-splits-in-macvim/8024859#8024859
let g:auto_resize_width = &columns
function! s:AutoResize()
    let win_width = winwidth(winnr())
    if win_width < g:auto_resize_width
        let &columns += g:auto_resize_width + 1
    elseif win_width > g:auto_resize_width
        let &columns -= g:auto_resize_width + 1
    endif
    wincmd =
endfunction

augroup AutoResize
    autocmd!
    autocmd WinEnter * call <sid>AutoResize()
augroup END
