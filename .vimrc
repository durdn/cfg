" Pathogen setup   "{{{
" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

"}}}
" Global settings and variables"{{{
"====================================================
if has('syntax') && (&t_Co > 2)
  syntax on
endif

set encoding=utf-8
set nocompatible hidden ignorecase smartcase title expandtab autoindent
set nobackup noswapfile showmode showcmd ttyfast gdefault
set hlsearch visualbell shiftround incsearch nu gdefault wildmenu nowrap
let mapleader = ","
let maplocalleader = ";"
set copyindent          " copy the previous indentation on autoindenting
set showmatch           " set show matching parenthesis
set noerrorbells        " don't beep
set tabstop=2
set softtabstop=2
set shiftwidth=2
set history=1000
set undolevels=1000     " use many levels of undo
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc
set scrolloff=3
set shortmess=atI
set guioptions=a        " get rid of stupid scrollbar/menu/tabs/etc
set guifont=Terminus:h12
set whichwrap=h,l,~,[,]
set ff=unix             " set file type to unix
set foldmethod=marker   " sets the fold method to {{ }} markers
set backspace=indent,eol,start
set laststatus=2
set noequalalways
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [ascii=\%03.3b]\ [hex=\%02.2B]\ [%04l,%04v][%p%%]\ [len=%L]\ %{fugitive#statusline()}
colorscheme ir_black

filetype plugin indent on

"}}}
" Keyboard Shortcuts and remappings   "{{{
"==================================
nnoremap ' `
nnoremap ` '
"nnoremap / /\v
"vnoremap / /\v
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" ease of use keyboard mappings (why do I care about top/bottom of screen?)
nnoremap H ^
nnoremap L $
" : changes with less keystrokes
nnoremap ; :
nnoremap j gj
nnoremap k gk
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" buffer switching/management, might as well use those keys for something useful
map <Right> :bnext<CR>
imap <Right> <ESC>:bnext<CR>
map <Left> :bprev<CR>
imap <Left> <ESC>:bprev<CR>
map <Del> :bd<CR>
"paste last yanked string skipping deletes"
nmap <silent> <leader>p "0p
nmap <silent> <leader>P "0P
"hide hightlight of searches"
nmap <silent> <leader>n :silent :nohlsearch<CR>
set listchars=tab:\|\ ,trail:·,eol:$
"show spaces"
nmap <silent> <leader>s :set nolist!<CR>
"show line numbers"
nmap <silent> <leader>l :set nonu!<CR>
"maximize only this window"
nmap <silent> <leader>m :only<CR>
"toggle minibuf explorer
nmap <silent> <leader>M :TMiniBufExplorer<CR>
"vertical split"
nmap <silent> <leader>v :vsplit<CR>
"horizontal split"
nmap <silent> <leader>f :split<CR>
"wrap lines"
nmap <silent> <leader>w :set nowrap!<CR>
"close viewport buffer"
nmap <silent> <leader>x :hid<CR>
"close buffer"
nmap <silent> <leader>X :bd<CR>
"edit the .vimrc"
nmap <silent> <leader>e :e ~/.vimrc<CR>
"open a scratch file
nmap <silent> <leader>h :e ~/scratch.txt<CR>
"reload the .vimrc"
"
nmap <silent> <leader>rv :source ~/.vimrc<CR>

" found as comment on reddit
" don't show the preview pane for some omni completions
set completeopt-=preview
" toggle between number and relative number on ,l
nnoremap <leader>l :call ToggleRelativeAbsoluteNumber()<CR>
function! ToggleRelativeAbsoluteNumber()
  if &number
    set relativenumber
  else
    set number
  endif
endfunction

"picked up from carlhuda janus
" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>nf
nmap <leader>nf :e <C-R>=expand("%:p:h") . "/" <CR> <BS>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
nmap <leader>nt :tabe <C-R>=expand("%:p:h") . "/" <CR> <BS>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR> <BS>

" Reload all snipmate snippets
nmap <silent> <leader>rs :call ReloadAllSnippets()<cr>
" Edit snippets
nmap <silent> <leader>re :e ~/.vim/bundle/snipmate.vim/snippets/<cr>

" capital W/Q same as w/q in command mode
cnoreabbrev W w
cnoreabbrev Q q


"}}}
" Conditional configuration (macvim,gui,etc)"{{{
" ==================================
if has('unix')
    " xml formatting
    map <F2> <Esc>:1,$!xmllint --format -<CR>
    "remap omny completion to Ctrl-n
    inoremap <C-n> <C-x><C-o>
    "write a read only file that needs sudo first
    cmap w!! w !sudo tee % >/dev/null
    "greps entire word under cursor and you can go through the matches with "ctrl-n,p
    nmap <silent> <leader>gw "yyiw:grep -r <C-R>y *<CR>
    " grep shortcut to search recursively an extension
    nmap <leader>gr :grep -r  **/*.jsp<left><left><left><left><left><left><left><left><left>

    "c-n/p goes to the next prev match and list entries again
    map <C-n> :cn<CR>:cl<CR>
    map <C-p> :cp<CR>:cl<CR>
endif
if has('gui_gtk')
    set guifont=Terminus
endif
if has('gui_macvim')
    winpos 720 0
    " goes to real fullscreen on OS X
    set fuoptions=maxvert,maxhorz
endif
if has('gui_win32')
  winpos 600 0
  "status line does not work with fugitive on win32
  set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [ascii=\%03.3b]\ [hex=\%02.2B]\ [%04l,%04v][%p%%]\ [len=%L]\ 
  "overwrite mapping to edit the .vimrc"
  nmap <silent> <leader>e :e ~/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>rv :source ~/_vimrc<CR>
  " has proper command-t compiled
  map <leader>t :CommandT<CR>
endif
if has('gui_running')
    syntax on
    set cursorline 
    set ruler
    set lines=85
    set columns=119
    set guioptions-=T  " no toolbar
    inoremap <C-space> <C-x><C-o>
else
    inoremap <Nul> <C-x><C-o>
endif
" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif


"}}}
" Plugins configuration"{{{
" ===================================================================

" --- Nerdtree ---
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$']
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

if has('ruby')
  " --- Fuzzy Finder --- 
  "let g:fuzzy_ignore = "*.log"
  "let g:fuzzy_matching_limit = 70
  "let g:fuzzy_ignore = "*.pyc,*.swp"
  "map <leader>t :FuzzyFinderTextMate<CR>
  map <leader>b :FuzzyFinderBuffer<CR>
  "let g:fuzzy_roots
  "let g:fuzzy_ceiling
  "map <leader>t :FufFile<CR>
endif

" --- Minibuf --- 
" let g:miniBufExplMapWindowNavVim = 1 
" let g:miniBufExplUseSingleClick = 1
" let g:miniBufExplorerMoreThanOne=0

" -- Snipmate Django extension --
":set ft=python.django
":set ft=html.django_template
au BufRead,BufNewFile *.jsp set ft=jsp.html
au BufRead,BufNewFile *.html set ft=html.django_template
au BufRead,BufNewFile *.json set ft=json
au BufRead,BufNewFile *.java set ft=java
"au FileType html set ft=django_template.html
au FileType python set ft=python.django " For SnipMate
au FileType python setlocal sw=4 sts=4 et tw=200 sta
au FileType jsp setlocal sw=4 sts=4 ts=4 noet tw=200 sta
au FileType java setlocal sw=4 sts=4 ts=4 noet tw=200 sta

" -- VimClojure setup --
let vimclojure#NailgunClient = "/Users/nick/bin/ng"
let clj_want_gorilla = 1

"}}}
"Source of vim wisdom "{{{
"   http://items.sjbach.com/319/configuring-vim-right
"   http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"   http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
"}}}

