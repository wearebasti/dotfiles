" #!/usr/bin/vim -nNesc:let&verbose=1|let&viminfo=""|source%|echo""|qall!
set shell=zsh
set nocp
execute pathogen#infect()
set filetype=unknown
set background=dark
colorscheme darkblue

if has('unix')
    set guifont=Hack
endif
if has('macosx')
    set clipboard=unnamed
    set guifont=Hack:h12
endif
set number
set confirm
set guioptions=agimrLtTbH
set noequalalways
set laststatus=2
set scrolloff=2
set ttyfast
set foldmethod=indent
set foldlevel=99
set cursorline

set backspace=indent,eol,start
set smartindent
set display="lastline,uhex"
set selection=exclusive
" set syntax=on  -- is this needed on macOS?
syntax on
set nowrap
set textwidth=80
set wrapmargin=0
set undolevels=500

set endofline
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set hlsearch
set ignorecase
set smartcase
set incsearch

set secure
set modeline

set colorcolumn=+1

" activate ctrlp and use splitright to open in right split on ctrl-v
set runtimepath^=~/.vim/bundle/ctrlp.vim
set splitright

" activate strip whitespace on save via `vim-better-whitespace-master`
let strip_whitespace_on_save = 1

if !exists("*s:SetupSyntastic")
" setup syntastic
let s:pylintrc = ""
let s:venv = $VIRTUAL_ENV
function s:SetupSyntastic()
    if s:pylintrc == "" || s:venv == ""
        let g:syntastic_python_pylint_post_args = "--jobs 2 --msg-template '{path}:{line}:{column}:{C}: [{msg_id} {symbol}, {obj}] {msg}'"
        let x = fnamemodify(resolve(expand("%:p")), ":h")
        let xl = ""
        while 1
            if x == xl || (s:pylintrc != "" && s:venv != "")
                break
            endif

            if s:pylintrc == "" && filereadable(x . "/pylintrc")
                let s:pylintrc = x . "/pylintrc"
            endif
            if s:venv == "" && xl != x && fnamemodify(x, ":t") == '.virtualenvs'
                let s:venv = xl
            endif

            let xl = x
            let x = fnamemodify(x, ":h")
        endwhile

        if s:pylintrc != ""
            let g:syntastic_python_pylint_post_args .= " --rcfile " . s:pylintrc
        endif

        if s:venv != "" && s:venv != $VIRTUAL_ENV
            let $PATH = s:venv . '/bin:' . $PATH
        endif
    endif

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_python_checkers = ['pylint', 'flake8']
endfunction
autocmd FileType python call s:SetupSyntastic()
endif
" /setup syntastic

autocmd FileType python setlocal fdc=1
autocmd FileType python setlocal foldmethod=expr
autocmd FileType python setlocal tw=78
let python_highlight_all=1
let python_slow_sync=1

autocmd FileType c setlocal fdc=1
autocmd FileType c setlocal foldmethod=syntax
autocmd FileType c setlocal tw=78
autocmd FileType c setlocal foldlevel=0
let c_space_errors=1
let c_no_comment_fold=1

nmap <F5> :wa<CR>:!venvexec.sh % nosetests -vv --with-doctest %<CR>
nmap <F6> :wa<CR>:!venvexec.sh % py.test -vv --doctest-modules %<CR>
nmap <f8> :wa<CR>:!venvexec.sh % flake8 %<CR>
nmap <F9> :wa<CR>:!venvexec.sh % /usr/bin/env python %<CR>

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" visual mode search
vnorem // y/<c-r>"<cr>
vnorem ?? y?<c-r>"<cr>
