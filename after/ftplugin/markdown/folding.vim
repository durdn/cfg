" Fold expressions {{{1
function! StackedMarkdownFolds()
  if HeadingDepth(v:lnum) > 0
    return ">1"
  else
    return "="
  endif
endfunction

function! NestedMarkdownFolds()
  let depth = HeadingDepth(v:lnum)
  if depth > 0
    return ">".depth
  else
    return "="
  endif
endfunction

" Helpers {{{1
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! HeadingDepth(lnum)
  let level=0
  let thisline = getline(a:lnum)
  let hashCount = len(matchstr(thisline, '^#\{1,6}'))
  if hashCount > 0
    let level = hashCount
  else
    if thisline != ''
      let nextline = getline(a:lnum + 1)
      if nextline =~ '^==='
        let level = 1
      elseif nextline =~ '^---'
        let level = 2
      endif
    endif
  endif
  if level > 0 && LineIsFenced(a:lnum)
    " Ignore # or === if they appear within fenced code blocks
    let level = 0
  endif
  return level
endfunction

function! LineIsFenced(lnum)
  if exists("b:current_syntax") && b:current_syntax ==# 'markdown'
    " It's cheap to check if the current line has 'markdownCode' syntax group
    return s:HasSyntaxGroup(a:lnum, 'markdownCode')
  else
    " Using searchpairpos() is expensive, so only do it if syntax highlighting
    " is not enabled
    return s:HasSurroundingFencemarks(a:lnum)
  endif
endfunction

function! s:HasSyntaxGroup(lnum, targetGroup)
  let syntaxGroup = map(synstack(a:lnum, 1), 'synIDattr(v:val, "name")')
  for value in syntaxGroup
    if value =~ '\vmarkdown(Code|Highlight)'
      return 1
    endif
  endfor
endfunction

function! s:HasSurroundingFencemarks(lnum)
  let cursorPosition = [line("."), col(".")]
  call cursor(a:lnum, 1)
  let startFence = '\%^```\|^\n\zs```'
  let endFence = '```\n^$'
  let fenceEndPosition = searchpairpos(startFence,'',endFence,'W')
  call cursor(cursorPosition)
  return fenceEndPosition != [0,0]
endfunction

function! s:FoldText()
  let level = HeadingDepth(v:foldstart)
  let indent = repeat('#', level)
  let title = substitute(getline(v:foldstart), '^#\+\s*', '', '')
  let foldsize = (v:foldend - v:foldstart)
  let linecount = '['.foldsize.' line'.(foldsize>1?'s':'').']'
  return indent.' '.title.' '.linecount
endfunction

" API {{{1
function! ToggleMarkdownFoldexpr()
  if &l:foldexpr ==# 'StackedMarkdownFolds()'
    setlocal foldexpr=NestedMarkdownFolds()
  else
    setlocal foldexpr=StackedMarkdownFolds()
  endif
endfunction
command! -buffer FoldToggle call ToggleMarkdownFoldexpr()

" Setup {{{1
if !exists('g:markdown_fold_style')
  let g:markdown_fold_style = 'stacked'
endif

setlocal foldmethod=expr
let &l:foldtext = s:SID() . 'FoldText()'
let &l:foldexpr =
  \ g:markdown_fold_style ==# 'nested'
  \ ? 'NestedMarkdownFolds()'
  \ : 'StackedMarkdownFolds()'

" Teardown {{{1
let b:undo_ftplugin .= '
  \ | setlocal foldmethod< foldtext< foldexpr<
  \ | delcommand FoldToggle
  \ '
" vim:set fdm=marker:
