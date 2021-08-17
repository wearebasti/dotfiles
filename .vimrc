set shell=zsh
set nocp

" Use vim-plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'tpope/vim-fugitive'

call plug#end()

" Disable jedi completions in sake of deoplete-jedi
let g:jedi#completions_enabled = 0

" Make sure editorconfig & fugitive work together
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

set filetype=unknown
set background=dark
colorscheme darkblue

if has('unix')
    set guifont=Hack\ 9
    set clipboard=unnamedplus
endif
if has('macosx')
    set clipboard=unnamed
    set guifont=Hack:h12
endif

" set vimdir
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Set `tags` for ctags
set tags=tags;/

set clipboard=unnamed
set guifont=Hack:h12

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

" activate strip whitespace on save via `vim-better-whitespace`
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

autocmd FileType python setlocal fdc=1
autocmd FileType python setlocal foldmethod=expr
autocmd FileType python setlocal tw=78
let python_highlight_all=1
let python_slow_sync=1

let c_space_errors=1
let c_no_comment_fold=1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" visual mode search
vnorem // y/<c-r>"<cr>
vnorem ?? y?<c-r>"<cr>
