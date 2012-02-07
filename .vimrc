" .vimrc
" Author: Nicola Paolucci <nick@durdn.com>
" Source: http://github.com/durdn/cfg/.vimrc

" Preamble with Pathogen   "{{{

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

"}}}
" Basic settings and variables"{{{
if has('syntax') && (&t_Co > 2)
  syntax on
endif

colorscheme ir_black
set encoding=utf-8
set nocompatible hidden ignorecase smartcase title expandtab autoindent
set nobackup noswapfile showmode showcmd ttyfast gdefault
set hlsearch visualbell shiftround incsearch nu wildmenu nowrap
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
set listchars=tab:\|\ ,trail:·,eol:¬
set wildmenu
" don't show the preview pane for some omni completions
set completeopt-=preview

" Save when losing focus
au FocusLost * :wa

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Wildmenu completion {{{

set wildmode=list:longest,list:full
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.jar,*.war,*.ear                " java formats
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=classes
set wildignore+=lib
set wildignore+=*/.m2/*                          " Maven
set wildignore+=*/target/*                       " Java target folders

" }}}


" }}}
" Abbreviations {{{

function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction

call MakeSpacelessIabbrev('drd/',  'http://durdn.com/')
call MakeSpacelessIabbrev('bb/',  'http://bitbucket.org/')
call MakeSpacelessIabbrev('bbd/', 'http://bitbucket.org/durdn/')
call MakeSpacelessIabbrev('gh/',  'http://github.com/')
call MakeSpacelessIabbrev('ghd/', 'http://github.com/durdn/')

iabbrev np@ nick@durdn.com

"}}}
" Quick editing  {{{

"edit shortcuts list"
nnoremap <leader>em <C-w>s<C-w>j<C-w>L:e ~/.vim/mappings.txt<cr>
"edit the .bashrc"
nmap <silent> <leader>eb :e ~/.bashrc<CR>
"edit the .vimrc"
nmap <silent> <leader>ev :e ~/.vimrc<CR>
"nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e ~/.vimrc<cr>
"open a scratch file
nmap <silent> <leader>eh :e ~/scratch.txt<CR>
"reload the .vimrc"
nmap <silent> <leader>rv :source ~/.vimrc<CR>
" Reload all snipmate snippets
nmap <silent> <leader>rs :call ReloadAllSnippets()<cr>
" Edit snippets
nmap <silent> <leader>es :e ~/.vim/bundle/durdn-customisation/snippets/<cr>


" }}}
" Keyboard Shortcuts and remappings   "{{{

" Repeat last command and put cursor at start of change 
nnoremap . .`[
nnoremap ' `
nnoremap ` '
nnoremap / /\v
vnoremap / /\v
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
" Don't move on *
nnoremap * *<c-o>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" capital W/Q same as w/q in command mode
cnoreabbrev W w
cnoreabbrev Q q

" buffer switching/management, might as well use those keys for something useful
map <Right> :bnext<CR>
imap <Right> <ESC>:bnext<CR>
map <Left> :bprev<CR>
imap <Left> <ESC>:bprev<CR>
map <Del> :bd<CR>

"hide hightlight of searches"
nmap <silent> <leader>n :silent :nohlsearch<CR>
nmap <silent> // :nohlsearch<CR>
"show spaces"
nmap <silent> <leader>s :set nolist!<CR>
"show line numbers"
nmap <silent> <leader>l :set nonu!<CR>
"maximize only this window"
nmap <silent> <leader>m :only<CR>
"vertical split"
nmap <silent> <leader>v :bel :vne<CR>
"horizontal split"
nmap <silent> <leader>f :bel :new<CR>
"wrap lines"
nmap <silent> <leader>w :set nowrap!<CR>
"close viewport buffer"
nmap <silent> <leader>x :hid<CR>
"close buffer"
nmap <silent> <leader>X :bd<CR>
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" leader leader alias ,, to go back to previous buffer
nnoremap <leader><leader> <c-^>
" use jk instead than <esc>
inoremap jk <esc>
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
" Normal mode: <Leader>nt
nmap <leader>nt :tabe <C-R>=expand("%:p:h") . "/" <CR> <BS>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR> <BS>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Clean whitespace
map <leader>W  :%s/\s\+$//<cr>:let @/=''<CR>

" Nerd tree find current file
nnoremap <silent> <C-\> :NERDTreeFind<CR>

"Go to last edit location with ,.
nnoremap ,. '.

" copy current filename into system clipboard - mnemonic: (c)urrent(f)ilename
nnoremap <silent> ,cf :let @* = expand("%:p")<CR>

" (c)opy (c)ommand - which allows us to execute
" the line we're looking at (it does so by yy-copy, colon
" to get to the command mode, C-f to get to history editing
" p to paste it, C-c to return to command mode, and CR to execute
nmap <silent> ,cc yy:<C-f>p<C-c><CR>

"open up a git grep line, with a quote started for the search
nnoremap ,gg :GitGrep ""<left>

"git grep the current word using K (mnemonic Kurrent)
nnoremap <silent> K :GitGrep <cword><CR>

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

    "c-n/p goes to the next prev match and list entries again
    map <C-n> :cn<CR>:cl<CR>
    map <C-p> :cp<CR>:cl<CR>
endif
if has('gui_gtk')
    set guifont=Terminus
endif
if has('gui_macvim')
    "terminus on osx is slightly smaller so make it 14px
    set guifont=Terminus:h14
    winpos 720 0
    " goes to real fullscreen on OS X
    set fuoptions=maxvert,maxhorz
    macmenu &File.New\ Tab key=<nop>
"    map <leader>t <Plug>PeepOpen
endif
if has('gui_win32')
  winpos 600 0
  "status line does not work with fugitive on win32
  set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [ascii=\%03.3b]\ [hex=\%02.2B]\ [%04l,%04v][%p%%]\ [len=%L]\ 
  "overwrite mapping to edit the .vimrc"
  nmap <silent> <leader>ev :e ~/_vimrc<CR>
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

" ctrlp {{{

let g:ctrlp_map = '<leader>t'
let g:ctrlp_dotfiles = 1
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_mruf_exclude = 'build/.*\|/temp/.*\|.*jar$\|.*war$\|.*ear$|\.*zip$' " MacOSX/Linux

" }}}
" Nerdtree "{{{
" autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd FocusGained * call s:UpdateNERDTree()
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" If the parameter is a directory, cd into it
function! s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0 
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function! s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

" Utility functions to create file commands
function! s:CommandCabbr(abbreviation, expansion)
  execute 'cabbrev ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

function! s:FileCommand(name, ...)
  if exists("a:1")
    let funcname = a:1
  else
    let funcname = a:name
  endif

  execute 'command -nargs=1 -complete=file ' . a:name . ' :call ' . funcname . '(<f-args>)'
endfunction

function! s:DefineCommand(name, destination)
  call s:FileCommand(a:destination)
  call s:CommandCabbr(a:name, a:destination)
endfunction

" Public NERDTree-aware versions of builtin functions
function! ChangeDirectory(dir, ...)
  execute "cd " . fnameescape(a:dir)
  let stay = exists("a:1") ? a:1 : 1

  NERDTree

  if !stay
    wincmd p
  endif
endfunction

function! Touch(file)
  execute "!touch " . shellescape(a:file, 1)
  call s:UpdateNERDTree()
endfunction

function! Remove(file)
  let current_path = expand("%")
  let removed_path = fnamemodify(a:file, ":p")

  if (current_path == removed_path) && (getbufvar("%", "&modified"))
    echo "You are trying to remove the file you are editing. Please close the buffer first."
  else
    execute "!rm " . shellescape(a:file, 1)
  endif

  call s:UpdateNERDTree()
endfunction

function! Mkdir(file)
  execute "!mkdir " . shellescape(a:file, 1)
  call s:UpdateNERDTree()
endfunction

function! Edit(file)
  if exists("b:NERDTreeRoot")
    wincmd p
  endif

  execute "e " . fnameescape(a:file)

ruby << RUBY
  destination = File.expand_path(VIM.evaluate(%{system("dirname " . shellescape(a:file, 1))}))
  pwd         = File.expand_path(Dir.pwd)
  home        = pwd == File.expand_path("~")

  if home || Regexp.new("^" + Regexp.escape(pwd)) !~ destination
    VIM.command(%{call ChangeDirectory(fnamemodify(a:file, ":h"), 0)})
  end
RUBY
endfunction

" Define the NERDTree-aware aliases
call s:DefineCommand("cd", "ChangeDirectory")
call s:DefineCommand("touch", "Touch")
call s:DefineCommand("rm", "Remove")
"call s:DefineCommand("e", "Edit")
call s:DefineCommand("mkdir", "Mkdir")

set autochdir
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$']
let NERDTreeChDirMode=2
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
"}}}
" Fuzzy Finder {{{
if has('ruby')
  " --- Fuzzy Finder --- 
  "let g:fuzzy_ignore = "*.log"
  "let g:fuzzy_matching_limit = 70
  "let g:fuzzy_ignore = "*.pyc,*.swp"
  map <leader>b :FuzzyFinderBuffer<CR>
  "let g:fuzzy_roots
  "let g:fuzzy_ceiling
  "map <leader>t :FufFile<CR>
endif
" }}}
" Minibuf {{{
" let g:miniBufExplMapWindowNavVim = 1 
" let g:miniBufExplUseSingleClick = 1
" let g:miniBufExplorerMoreThanOne=0
" }}}

" -- Snipmate Django extension --
":set ft=python.django
":set ft=html.django_template
au BufRead,BufNewFile *.jsp set ft=jsp.html
au BufRead,BufNewFile *.jspf set ft=jsp.html
au BufRead,BufNewFile *.html set ft=html.django_template
au BufRead,BufNewFile *.json set ft=json
au BufRead,BufNewFile *.java set ft=java
"au FileType html set ft=django_template.html
au FileType python set ft=python.django " For SnipMate
au FileType python setlocal sw=4 sts=4 et tw=200 sta
au FileType jsp setlocal sw=4 sts=4 ts=4 noet tw=200 sta
au FileType java setlocal sw=4 sts=4 ts=4 noet tw=200 sta

"}}}

