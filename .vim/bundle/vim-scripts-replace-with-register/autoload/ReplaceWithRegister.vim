" ReplaceWithRegister.vim: Replace text with the contents of a register. 
"
" DEPENDENCIES:
"   - repeat.vim (vimscript #2136) autoload script (optional). 
"   - visualrepeat.vim (vimscript #3848) autoload script (optional). 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.30.005	06-Dec-2011	Retire visualrepeat#set_also(); use
"				visualrepeat#set() everywhere. 
"   1.30.004	21-Oct-2011	Employ repeat.vim to have the expression
"				re-evaluated on repetition of the
"				operator-pending mapping. 
"   1.30.003	30-Sep-2011	Avoid clobbering of expression register so that
"				a command repeat is able to re-evaluate the
"				expression. 
"				Undo parallel <Plug>ReplaceWithRegisterRepeat...
"				mappings, as this is now handled by the enhanced
"				repeat.vim plugin. 
"   1.30.002	27-Sep-2011	Adaptations for blockwise replace: 
"				- If the register contains just a single line,
"				  temporarily duplicate the line to match the
"				  height of the blockwise selection. 
"				- If the register contains multiple lines, paste
"				  as blockwise. 
"   1.30.001	24-Sep-2011	Moved functions from plugin to separate autoload
"				script. 
"				file creation

function! ReplaceWithRegister#SetRegister()
    let s:register = v:register
endfunction
function! ReplaceWithRegister#IsExprReg()
    return (s:register ==# '=')
endfunction

function! s:CorrectForRegtype( type, register, regType, pasteText )
    if a:type ==# 'visual' && visualmode() ==# "\<C-v>" || a:type[0] ==# "\<C-v>"
	" Adaptations for blockwise replace. 
	let l:pasteLnum = len(split(a:pasteText, "\n"))
	if a:regType ==# 'v' || a:regType ==# 'V' && l:pasteLnum == 1
	    " If the register contains just a single line, temporarily duplicate
	    " the line to match the height of the blockwise selection. 
	    let l:height = line("'>") - line("'<") + 1
	    if l:height > 1
		call setreg(a:register, join(repeat(split(a:pasteText, "\n"), l:height), "\n"), "\<C-v>")
		return 1
	    endif
	elseif a:regType ==# 'V' && l:pasteLnum > 1
	    " If the register contains multiple lines, paste as blockwise. 
	    call setreg(a:register, '', "a\<C-v>")
	    return 1
	endif
    elseif a:regType ==# 'V' && a:pasteText =~# '\n$'
	" Our custom operator is characterwise, even in the
	" ReplaceWithRegisterLine variant, in order to be able to replace less
	" than entire lines (i.e. characterwise yanks). 
	" So there's a mismatch when the replacement text is a linewise yank,
	" and the replacement would put an additional newline to the end.
	" To fix that, we temporarily remove the trailing newline character from
	" the register contents and set the register type to characterwise yank. 
	call setreg(a:register, strpart(a:pasteText, 0, len(a:pasteText) - 1), 'v')
	
	return 1
    endif

    return 0
endfunction
function! s:ReplaceWithRegister( type )
    " With a put in visual mode, the selected text will be replaced with the
    " contents of the register. This works better than first deleting the
    " selection into the black-hole register and then doing the insert; as 
    " "d" + "i/a" has issues at the end-of-the line (especially with blockwise
    " selections, where "v_o" can put the cursor at either end), and the "c"
    " commands has issues with multiple insertion on blockwise selection and
    " autoindenting. 
    " With a put in visual mode, the previously selected text is put in the
    " unnamed register, so we need to save and restore that. 
    let l:save_clipboard = &clipboard
    set clipboard= " Avoid clobbering the selection and clipboard registers. 
    let l:save_reg = getreg('"')
    let l:save_regmode = getregtype('"')

    " Note: Must not use ""p; this somehow replaces the selection with itself?! 
    let l:pasteCmd = (s:register ==# '"' ? 'p' : '"' . s:register . 'p')
    if s:register ==# '='
	" Cannot evaluate the expression register within a function; unscoped
	" variables do not refer to the global scope. Therefore, evaluation
	" happened earlier in the mappings. 
	" To get the expression result into the buffer, we use the unnamed
	" register; this will be restored, anyway. 
	call setreg('"', g:ReplaceWithRegister_expr)
	call s:CorrectForRegtype(a:type, '"', getregtype('"'), g:ReplaceWithRegister_expr)
	" Must not clean up the global temp variable to allow command
	" repetition. 
	"unlet g:ReplaceWithRegister_expr
	let l:pasteCmd = 'p'
    endif
    try
	if a:type ==# 'visual'
	    execute 'normal! gv' . l:pasteCmd
	else
	    " Note: Need to use an "inclusive" selection to make `] include the
	    " last moved-over character. 
	    let l:save_selection = &selection
	    set selection=inclusive
	    try
		execute 'normal! `[' . (a:type ==# 'line' ? 'V' : 'v') . '`]' . l:pasteCmd
	    finally
		let &selection = l:save_selection
	    endtry
	endif
    finally
	call setreg('"', l:save_reg, l:save_regmode)
	let &clipboard = l:save_clipboard
    endtry
endfunction
function! ReplaceWithRegister#Operator( type, ... )
    let l:pasteText = getreg(s:register, 1) " Expression evaluation inside function context may cause errors, therefore get unevaluated expression when s:register ==# '='. 
    let l:regType = getregtype(s:register)
    let l:isCorrected = s:CorrectForRegtype(a:type, s:register, l:regType, l:pasteText)
    try
	call s:ReplaceWithRegister(a:type)
    finally
	if l:isCorrected
	    " Undo the temporary change of the register. 
	    " Note: This doesn't cause trouble for the read-only registers :, .,
	    " %, # and =, because their regtype is always 'v'. 
	    call setreg(s:register, l:pasteText, l:regType)
	endif
    endtry

    if a:0
	silent! call repeat#set(a:1)
    elseif s:register ==# '='
	" Employ repeat.vim to have the expression re-evaluated on repetition of
	" the operator-pending mapping. 
	silent! call repeat#set("\<Plug>ReplaceWithRegisterExpressionSpecial")
    endif
    silent! call visualrepeat#set("\<Plug>ReplaceWithRegisterVisual")
endfunction
function! ReplaceWithRegister#OperatorExpression()
    call ReplaceWithRegister#SetRegister()
    let &opfunc = 'ReplaceWithRegister#Operator'

    let l:keys = 'g@'

    if ! &l:modifiable || &l:readonly
	" Probe for "Cannot make changes" error and readonly warning via a no-op
	" dummy modification. 
	" In the case of a nomodifiable buffer, Vim will abort the normal mode
	" command chain, discard the g@, and thus not invoke the operatorfunc. 
	let l:keys = ":call setline(1, getline(1))\<CR>" . l:keys
    endif

    if v:register ==# '='
	" Must evaluate the expression register outside of a function. 
	let l:keys = ":let g:ReplaceWithRegister_expr = getreg('=')\<CR>" . l:keys
    endif

    return l:keys
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
