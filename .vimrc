" .vimrc
" Author: Nicola Paolucci <nick@durdn.com>
" Source: https://bitbucket.org/durdn/cfg/src

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
set nocompatible ignorecase smartcase
set nocindent noautoindent nosmartindent indentexpr= "disable autoindents
set tabstop=4 shiftwidth=4 expandtab "setup default tab/shift/expand
set showmode showcmd ttyfast
set guioptions=a            " hide scrollbars/menu/tabs
let mapleader = ","
let maplocalleader = ";"
set foldmethod=marker       " sets the fold method to {{{ }}} markers
set shortmess=atI           " disable welcome screen
set listchars=tab:\|\ ,trail:·,eol:¬
set nospell                 " disable spellcheck for code
" End Basic settings and variables}}}
" Auto-commands {{{

aug nick
  " Remove all autocommands for the current group.
  au!
  " .md extension is markdown
  au BufRead,BufNewFile *.md set ft=markdown foldlevel=2 wrap linebreak textwidth=0 wrapmargin=0 spell
  au BufRead,BufNewFile *.wp set ft=markdown foldlevel=2 wrap linebreak textwidth=0 wrapmargin=0 spell
  if v:version > 703
    au BufRead,BufNewFile *.md set colorcolumn=80
    au BufRead,BufNewFile *.wp set colorcolumn=80
  endif

  " Spelling on markdown
  au BufRead,BufNewFile *.md set spell
  au BufRead,BufNewFile *.go set ts=4
  " run go test on Dispatch
  au FileType go let b:dispatch = 'go build'
  " javascript tabstop 2 expandtab
  au BufRead,BufNewFile *.js set ft=javascript foldlevel=2 ts=2 sw=2 expandtab textwidth=79
  if v:version > 703
    au BufRead,BufNewFile *.js set colorcolumn=80
  endif
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
"vertical split"
nmap <silent> <leader>v :bel :vne<CR>
"horizontal split"
nmap <silent> <leader>f :bel :new<CR>
"close viewport buffer"
nmap <silent> <leader>x :hid<CR>
" }}}
" Wordpress workarounds {{{
nmap <leader>pr :%s/\`\([^`]\+\)`/\<span class=\"text codecolorer\"\>\1<\/span>/p<cr>:set nohlsearch<CR>
nmap <leader>pu :%s/<span.\{-}>\(.\{-}\)<\/span>/`\1`/p<cr>:set nohlsearch<CR>
" }}}
" Code on retina {{{
nnoremap <silent> <leader>9 :call CodeOnRetina()<CR>
let g:retina_code_environment_on = 0
function! CodeOnRetina()
  set fuopt=maxvert
  if g:retina_code_environment_on
    if has('gui_macvim')
      set noantialias|set gfn=Terminus\ (TTF):h14|set co=80
    else
      set noantialias|set gfn=Terminus\ (TTF):h14|set co=80
    endif
    let g:retina_code_environment_on = 0
  else
    set antialias|set gfn=Inconsolata:h16|set co=80
    let g:retina_code_environment_on = 1
  endif
endfunction
" }}}
" Writing environment {{{
nnoremap <silent> <leader>0 :call ToggleWritingEnvironment()<CR>
let g:writing_environment_on = 0
function! ToggleWritingEnvironment()
  set fuopt=maxvert
  if g:writing_environment_on
    if has('gui_macvim')
      set noantialias|set gfn=Terminus\ (TTF):h14|set co=80
    else
      set noantialias|set gfn=Terminus\ (TTF):h14|set co=80
    endif
    let g:writing_environment_on = 0
  else
    set antialias|set gfn=Inconsolata:h22|set co=180
"    set foldcolumn=12
    let g:writing_environment_on = 1
  endif
endfunction
" }}}
" Magic c-space OmniComplete "{{{
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
" }}}
" Paste and visual paste improvments {{{
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()
" }}}
" End Keyboard Shortcuts}}}
" Theme and Color {{{

set background=dark
colorscheme solarized
"font is antialiased Terminus
" set noantialias
set guifont=Terminus\ (TTF):h14
" set guifont=Hack:h14
"draw vertical column at 80
if v:version > 703
  set colorcolumn=80
endif
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
" Open dev tools content folder
nmap <silent> <leader>ec :e ~/.vim/bundle/solarized/colors/solarized.vim<CR>
" End Quick editing  }}}
" Plugins configuration"{{{

" Nerdtree "{{{
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
let NERDTreeIgnore=['node_modules$[[dir]]', '\.git$[[dir]]']
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
" vim-go {{{
let g:go_fmt_command = "goimports"
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>rr <Plug>(go-run)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
" }}}
" Vim Dispatch {{{
nnoremap <leader>gt :Dispatch<CR>
" }}}
" End Plugins configuration"}}}
" Platform specific configuration {{{
if has('gui_win64')
  set noantialias
  set guifont=Terminus:h12
  set lines=85
  nmap <silent> <leader>ev :e $HOME/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>rv :source $HOME/_vimrc<CR>
endif
if has('gui_win32')
  set noantialias
  set guifont=Terminus:h12
  set lines=85
  "overwrite mapping to edit the .vimrc"
  nmap <silent> <leader>ev :e $HOME/_vimrc<CR>
  "overwrite mapping to reload the .vimrc"
  nmap <silent> <leader>rv :source $HOME/_vimrc<CR>
endif
if has("gui_macvim")
  set fuopt=maxvert
  set noantialias
  set guifont=Terminus\ (TTF):h14
  "set guifont=Hack:h14
  command! ToggleFullScreen if &fu|set noantialias|set gfn=Terminus\ (TTF):h14|set co=80|set nofu|else|set antialias|set gfn=Inconsolata:h22|set co=100|set fu|endif
  an <silent> Window.Toggle\ Full\ Screen\ Mode :ToggleFullScreen<CR>
endif

" End Platform specific configuration }}}
