" Vim color scheme
"
" Name:         railscast.vim
" Maintainer:   Josh O'Rourke <jorourke23@gmail.com> 
" Last Change:  17 Aug 2007 
" License:      public domain
" Version:      1.1
"
" This theme is based on the Railscasts Textmate theme [1]. I used 
" Jo Vermeulen's "vibrantink" theme for Vim [2] as my template for 
" creating this theme.
"
" [1] http://railscasts.com/about 
" [2] http://www.vim.org/scripts/script.php?script_id=1794 

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "railscasts"

if has("gui_running")
  hi link htmlTag                     xmlTag
  hi link htmlTagName                 xmlTagName
  hi link htmlEndTag                  xmlEndTag

  highlight Normal                    guifg=#E6E1DC   guibg=#2B2B2B
  highlight Cursor                    guifg=#000000   guibg=#FFFFFF
  "highlight CursorLine               guibg=#323300
 
  highlight Comment                   guifg=#BC9458   gui=italic
  highlight Constant                  guifg=#6D9CBE
  highlight Define                    guifg=#CC7833
  highlight Error                     guifg=#FFFFFF   guibg=#990000
  highlight Function                  guifg=#FFC66D   gui=NONE
  highlight Identifier                guifg=#6D9CBE   gui=NONE
  highlight Include                   guifg=#CC7833   gui=NONE
  highlight Keyword                   guifg=#CC7833
  highlight LineNr                    guifg=#2B2B2B   guibg=#C0C0FF
  highlight Number                    guifg=#A5C261
  highlight PreProc                   guifg=#E6E1DC
  highlight Search                    guibg=#FFFF00
  highlight Statement                 guifg=#CC7833   gui=NONE
  highlight String                    guifg=#A5C261
  highlight Title                     guifg=#FFFFFF
  highlight Type                      guifg=#DA4939   gui=NONE
  highlight Visual                    guibg=#5A647E

  highlight DiffAdd                   guifg=#E6E1DC   guibg=#144212
  highlight DiffDelete                guifg=#E6E1DC   guibg=#660000
  
  highlight rubyBlockParameter        guifg=#FFFFFF
  highlight rubyClass                 guifg=#FFFFFF
  highlight rubyConstant              guifg=#DA4939
  highlight rubyInstanceVariable      guifg=#D0D0FF
  highlight rubyInterpolation         guifg=#519F50
  highlight rubyLocalVariableOrMethod guifg=#D0D0FF
  highlight rubyPredefinedConstant    guifg=#DA4939
  highlight rubyPseudoVariable        guifg=#FFC66D
  highlight rubyStringDelimiter       guifg=#A5C261
  
  highlight xmlTag                    guifg=#E8BF6A
  highlight xmlTagName                guifg=#E8BF6A
  highlight xmlEndTag                 guifg=#E8BF6A
endif
