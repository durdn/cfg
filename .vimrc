" .vimrc
" Author: Nicola Paolucci <nick@durdn.com>
" Source: https://bitbucket.org/durdn/cfg/src

" Preamble with Pathogen   "{{{
execute pathogen#infect()
"}}}
" Basic settings and variables"{{{
filetype plugin indent on
syntax on
set encoding=utf-8
set visualbell noerrorbells " don't beep
set hlsearch incsearch      " hightlight search and incremental search
set gdefault                " global replace by default
set nowrap                  " not wrap lines
set nu                      " show line numbers
set foldlevel=1             " default foldlevel 1 to see headings
set nobackup noswapfile     " stop backup and swap files
set nocompatible ignorecase smartcase expandtab autoindent
set showmode showcmd ttyfast
set guioptions=a            " hide scrollbars/menu/tabs
let mapleader = ","
let maplocalleader = ";"
set foldmethod=marker       " sets the fold method to {{{ }}} markers
" End Basic settings and variables}}}
" Keyboard Shortcuts and remappings   "{{{
"changes with less keystrokes
nnoremap ; :
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
"reload the .vimrc
nmap <silent> <leader>rv :source ~/.vimrc<CR>
"show spaces"
nmap <silent> <leader>s :set nolist!<CR>
"show line numbers"
nmap <silent> <leader>l :set nonu!<CR>
"wrap lines"
nmap <silent> <leader>w :set nowrap!<CR>
"hide hightlight of searches"
nmap <silent> // :nohlsearch<CR>
" End Keyboard Shortcuts}}}
" Theme and Color {{{
set background=dark
colorscheme solarized
"font is antialiased Terminus
set noantialias
set guifont=Terminus:h14
"draw vertical column at 80
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
set colorcolumn=80
" End Theme and Color }}}
" Plugins configuration"{{{
" Nerdtree "{{{
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
"}}}
" End Plugins configuration"}}}
