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

set nocompatible hidden ignorecase smartcase title expandtab autoindent
set nobackup noswapfile showmode showcmd cursorline ttyfast gdefault
set hlsearch visualbell shiftround incsearch nu gdefault wildmenu
let mapleader = ","
let maplocalleader = ";"
set copyindent          " copy the previous indentation on autoindenting
set showmatch           " set show matching parenthesis
set noerrorbells        " don't beep
set shiftwidth=2
set history=1000
set undolevels=1000     " use many levels of undo
set wildmode=list:longest
set scrolloff=3
set shortmess=atI
set guioptions=a        " get rid of stupid scrollbar/menu/tabs/etc
set guifont=Terminus:h12
set whichwrap=h,l,~,[,]
set tabstop=4
set ff=unix             " set file type to unix
set foldmethod=marker   " sets the fold method to {{ }} markers
set backspace=indent,eol,start

filetype plugin indent on

"}}}
" Keyboard Shortcuts and remappings   "{{{
"==================================
nnoremap ' `
nnoremap ` '
nnoremap / /\v
vnoremap / /\v
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" ease of use keyboard mappings (why do I care about top/bottom of screen?)
map H ^
map L $
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
set listchars=tab:>-,trail:·,eol:$
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
"reload the .vimrc"
nmap <silent> <leader>r :source ~/.vimrc<CR>
" xml formatting
map <F2> <Esc>:1,$!xmllint --format -<CR>
"remap omny completion to Ctrl-n
inoremap <C-n> <C-x><C-o>
"write a read only file that needs sudo first
cmap w!! w !sudo tee % >/dev/null
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

"}}}
" Conditional configuration (macvim,gui,etc)"{{{
" ==================================
if has('gui_macvim')
    winpos 720 0
    " goes to real fullscreen on OS X
    set fuoptions=maxvert,maxhorz
endif
if has('gui_win32')
  winpos 600 0
  "overwrite mapping to edit the .vimrc"
  nmap <silent> <leader>e :e ~/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>r :source ~/_vimrc<CR>
endif
if has('gui_running')
    syntax on
    set ruler
    set lines=85
    set columns=119
    set guioptions-=T  " no toolbar
    inoremap <C-space> <C-x><C-o>
    colorscheme ir_black
else
    inoremap <Nul> <C-x><C-o>
endif

"}}}
" Plugins configuration"{{{
" ===================================================================

" --- Nerdtree --- 
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

if has('ruby')
  " --- Fuzzy Finder --- 
  let g:fuzzy_ignore = "*.log"
  let g:fuzzy_matching_limit = 70
  let g:fuzzy_ignore = "*.pyc,*.swp"
  map <leader>t :FuzzyFinderTextMate<CR>
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
au BufRead,BufNewFile *.html set ft=html.django_template
au BufRead,BufNewFile *.json set ft=json
"au FileType html set ft=django_template.html
au FileType python set ft=python.django " For SnipMate
au FileType python setlocal sw=4 sts=4 et tw=90 sta

" -- VimClojure setup --
let vimclojure#NailgunClient = "/Users/nick/bin/ng"
let clj_want_gorilla = 1

"}}}
"Source of vim wisdom "{{{
"   http://items.sjbach.com/319/configuring-vim-right
"   http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"   http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
"}}}

