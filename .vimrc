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
set shortmess=atI           " disable welcome screen
" End Basic settings and variables}}}
" Auto-commands {{{

aug nick
  " Remove all autocommands for the current group.
  au!
  " .md extension is markdown
  au BufRead,BufNewFile *.md set ft=markdown foldlevel=2 textwidth=79 colorcolumn=80
  " Spelling on markdown
  au FileType markdown set spell
aug END
" End Auto-commands }}}
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
" Movements shortcuts {{{

" C-h/j/k/l to move between buffers
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Buffer switching/management, might as well use those keys for something useful
map <Right> :bnext<CR>
imap <Right> <ESC>:bnext<CR>
map <Left> :bprev<CR>
imap <Left> <ESC>:bprev<CR>
" Maximize only this window"
nmap <silent> <leader>m :only<CR>
" }}}
" End Keyboard Shortcuts}}}
" Theme and Color {{{

set background=dark
colorscheme solarized
"font is antialiased Terminus
set noantialias
set guifont=Terminus:h14
"draw vertical column at 80
set colorcolumn=80
" End Theme and Color }}}
" Quick editing  {{{

" Edit the .bashrc"
nmap <silent> <leader>eb :e ~/.bashrc<CR>
" Edit the .vimrc"
nmap <silent> <leader>ev :e ~/.vimrc<CR>
" Edit the .gitconfig"
nmap <silent> <leader>eg :e ~/.gitconfig<CR>
" Edit the .tmux.conf"
nmap <silent> <leader>et :e ~/.tmux.conf<CR>
" Edit slate configuration
nmap <silent> <leader>el :e ~/.slate<cr>
" Open a scratch file
nmap <silent> <leader>eh :e ~/scratch.txt<CR>
" End Quick editing  }}}
" Plugins configuration"{{{

" Nerdtree "{{{
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
"}}}
" Vim Airline {{{
set laststatus=2
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
" }}}
" ctrlp {{{

let g:ctrlp_map = '<c-p>'
let g:ctrlp_dotfiles = 1
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  'build/.*\|/temp/.*',
  \ 'file': '\.jar$\|\.ear$|\.zip',
  \ }
let g:ctrlp_user_command = 'git ls-files %s'
" }}}
" End Plugins configuration"}}}
" Platform specific configuration {{{
if has('gui_win64')
  set noantialias
  set guifont=Terminus:h12
  nmap <silent> <leader>ev :e $VIM/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>rv :source $VIM/_vimrc<CR>
endif
if has('gui_win32')
  set noantialias
  set guifont=Terminus:h12
  "overwrite mapping to edit the .vimrc"
  nmap <silent> <leader>ev :e $VIM/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>rv :source $VIM/_vimrc<CR>
endif
" End Platform specific configuration }}}
