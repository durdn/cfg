" ReplaceWithRegister.vim: Replace text with the contents of a register. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - repeat.vim (vimscript #2136) autoload script (optional). 
"   - visualrepeat.vim autoload script (optional). 
"
" Copyright: (C) 2008-2011 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.20.014	26-Apr-2011	BUG: ReplaceWithRegisterOperator didn't work
"				correctly with linewise motions (like "+"); need
"				to use a linewise visual selection in this case. 
"   1.20.013	23-Apr-2011	BUG: Text duplicated from yanked previous lines
"				is inserted on a replacement of a visual
"				blockwise selection. Need a special case, which
"				actually is tricky because of the detection of
"				the end-of-the-line in combination with having
"				two cursor positions (via v_o) in a blockwise
"				selection. Instead of following down that road,
"				switch to a put in visual mode in combination
"				with a save and restore of the unnamed register.
"				This should handle all cases and doesn't require
"				the autoindent workaround, neither. 
"   1.10.012	18-Mar-2011	The operator-pending mapping now also handles
"				'nomodifiable' and 'readonly' buffers without
"				function errors. Add checking and probing inside
"				s:ReplaceWithRegisterOperatorExpression(). 
"   1.10.011	17-Mar-2011	Add experimental support for repeating the
"				replacement also in visual mode through
"				visualrepeat.vim. Renamed vmap
"				<Plug>ReplaceWithRegisterOperator to
"				<Plug>ReplaceWithRegisterVisual for that. 
"				A repeat in visual mode will now apply the
"				previous line and operator replacement to the
"				selection text. A repeat in normal mode will
"				apply the previous visual mode replacement at
"				the current cursor position, using the size of
"				the last visual selection. 
"   1.03.010	07-Jan-2011	ENH: Better handling when buffer is
"				'nomodifiable' or 'readonly'. Using the trick of
"				prepending a no-op buffer modification before
"				invoking the functions. Using try...catch inside
"				s:ReplaceWithRegister() would break the needed
"				abort inside the :normal sequence of replacing
"				the selection, then inserting the register. The
"				disastrous result would be erroneous
"				interpretation of <C-O> as a normal mode
"				command! 
"   1.02.009	25-Nov-2009	Replaced the <SID>Count workaround with
"				:map-expr and an intermediate
"				s:ReplaceWithRegisterOperatorExpression. 
"   1.01.008	06-Oct-2009	Do not define "gr" mapping for select mode;
"				printable characters should start insert mode. 
"   1.00.007	05-Jul-2009	Renamed from ingooperators.vim. 
"				Replaced g:register with call to
"				s:SetRegister(). 
"	006	05-Mar-2009	BF: Besides 'autoindent', 'indentexpr' also
"				causes additional indent. Now completely turning
"				off all these things via the 'paste' option. 
"	005	23-Feb-2009	BF: When replacing a complete line over an
"				indented line (with 'Vgr' or 'grr'), the old
"				indent was kept. Now temporarily turning off
"				'autoindent' to avoid that. 
"	004	20-Feb-2009	BF: ReplaceWithRegisterOperator mapping didn't
"				work for "last line" G motion, because v:count1
"				defaulted to line 1. Now checking v:count and
"				mapping to <Nop> if no count was given. 
"	003	01-Feb-2009	Allowing repeating via '.' by avoiding the
"				script error about undefined variable
"				g:register. 
"				Put try...finally around temporary 'selection'
"				setting. 
"				ENH: Now allowing [count] in front of
"				gr{motion} (see :help ingo-opfunc for details)
"				and grr (via repeat.vim). 
"				Now correcting mismatch when replacement is
"				linewise by temporarily removing the trailing
"				newline. 
"	002	15-Aug-2008	Added {Visual}gr and grr mappings. 
"	001	11-Aug-2008	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_ReplaceWithRegister') || (v:version < 700)
    finish
endif
let g:loaded_ReplaceWithRegister = 1

function! s:SetRegister()
    let s:register = v:register
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
function! s:ReplaceWithRegisterOperator( type, ... )
    let l:pasteText = getreg(s:register)
    let l:regType = getregtype(s:register)
    if l:regType ==# 'V' && l:pasteText =~# '\n$'
	" Our custom operator is characterwise, even in the
	" ReplaceWithRegisterLine variant, in order to be able to replace less
	" than entire lines (i.e. characterwise yanks). 
	" So there's a mismatch when the replacement text is a linewise yank,
	" and the replacement would put an additional newline to the end.
	" To fix that, we temporarily remove the trailing newline character from
	" the register contents and set the register type to characterwise yank. 
	call setreg(s:register, strpart(l:pasteText, 0, len(l:pasteText) - 1), 'v')
    endif
    try
	call s:ReplaceWithRegister(a:type)
    finally
	if l:regType ==# 'V' && l:pasteText =~# '\n$'
	    " Undo the temporary change of the register. 
	    call setreg(s:register, l:pasteText, l:regType)
	endif
    endtry

    if a:0
	silent! call repeat#set(a:1)
	silent! call visualrepeat#set_also("\<Plug>ReplaceWithRegisterVisual")
    else
	silent! call visualrepeat#set("\<Plug>ReplaceWithRegisterVisual")
    endif
endfunction
function! s:ReplaceWithRegisterOperatorExpression( opfunc )
    call s:SetRegister()
    let &opfunc = a:opfunc

    let l:keys = 'g@'
    if ! &l:modifiable || &l:readonly
	" Probe for "Cannot make changes" error and readonly warning via a no-op
	" dummy modification. 
	" In the case of a nomodifiable buffer, Vim will abort the normal mode
	" command chain, discard the g@, and thus not invoke the operatorfunc. 
	let l:keys = "\"=''\<CR>p" . l:keys
    endif
    return l:keys
endfunction

" This mapping repeats naturally, because it just sets global things, and Vim is
" able to repeat the g@ on its own. 
nnoremap <expr> <Plug>ReplaceWithRegisterOperator <SID>ReplaceWithRegisterOperatorExpression('<SID>ReplaceWithRegisterOperator')
" This mapping needs repeat.vim to be repeatable, because it contains of
" multiple steps (visual selection + 'c' command inside
" s:ReplaceWithRegisterOperator). 
nnoremap <silent> <Plug>ReplaceWithRegisterLine     :<C-u>call setline(1, getline(1))<Bar>call <SID>SetRegister()<Bar>execute 'normal! V' . v:count1 . "_\<lt>Esc>"<Bar>call <SID>ReplaceWithRegisterOperator('visual', "\<lt>Plug>ReplaceWithRegisterLine")<CR>
" Repeat not defined in visual mode. 
vnoremap <silent> <SID>ReplaceWithRegisterVisual :<C-u>call setline(1, getline(1))<Bar>call <SID>SetRegister()<Bar>call <SID>ReplaceWithRegisterOperator('visual', "\<lt>Plug>ReplaceWithRegisterVisual")<CR>
vnoremap <silent> <script> <Plug>ReplaceWithRegisterVisual <SID>ReplaceWithRegisterVisual
nnoremap <expr> <SID>Reselect '1v' . (visualmode() !=# 'V' && &selection ==# 'exclusive' ? ' ' : '')
nnoremap <silent> <script> <Plug>ReplaceWithRegisterVisual <SID>Reselect<SID>ReplaceWithRegisterVisual

if ! hasmapto('<Plug>ReplaceWithRegisterOperator', 'n')
    nmap <silent> gr <Plug>ReplaceWithRegisterOperator
endif
if ! hasmapto('<Plug>ReplaceWithRegisterLine', 'n')
    nmap <silent> grr <Plug>ReplaceWithRegisterLine
endif
if ! hasmapto('<Plug>ReplaceWithRegisterVisual', 'x')
    xmap <silent> gr <Plug>ReplaceWithRegisterVisual
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
