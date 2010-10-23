"------------------------------------------------------------------------------
"  Description: Options setable by the rainbow_parenthsis plugin
"	   $Id: rainbow_parenthsis_options.vim 29 2007-09-24 11:40:36Z krischik@users.sourceforge.net $
"    Copyright: Copyright (C) 2006 Martin Krischik
"   Maintainer:	Martin Krischik (krischik@users.sourceforge.net)
"      $Author: krischik@users.sourceforge.net $
"	 $Date: 2007-09-24 13:40:36 +0200 (Mo, 24 Sep 2007) $
"      Version: 4.0
"    $Revision: 29 $
"     $HeadURL: https://vim-scripts.googlecode.com/svn/trunk/1561%20Rainbow%20Parenthsis%20Bundle/rainbow_parenthsis_options.vim $
"      History:	17.11.2006 MK rainbow_parenthsis_Options
"		01.01.2007 MK Bug fixing
"               09.10.2007 MK Now with round, square brackets, curly and angle
"                             brackets.
"	 Usage: copy content into your .vimrc and change options to your
"		likeing.
"    Help Page: rainbow_parenthsis.txt
"------------------------------------------------------------------------------

echoerr 'It is suggested to copy the content of ada_options into .vimrc!'
finish " 1}}}

" Section: rainbow_parenthsis options {{{1

" }}}1

" Section: Vimball options {{{1
:set noexpandtab fileformat=unix encoding=utf-8
:31,34 MkVimball rainbow_parenthsis-4.0.vba

autoload/rainbow_parenthsis.vim
doc/rainbow_parenthsis.txt
plugin/rainbow_parenthsis.vim
rainbow_parenthsis_options.vim

" }}}1

" Section: Tar options {{{1

tar --create --bzip2				\
   --file="rainbow_parenthsis-4.0.tar.bz2"	\
   rainbow_parenthsis_options.vim		\
   doc/rainbow_parenthsis.txt			\
   autoload/rainbow_parenthsis.vim		\
   plugin/rainbow_parenthsis.vim		;

" }}}1

"------------------------------------------------------------------------------
"   Copyright (C) 2006	Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence derainbow_parenthsiss.
"------------------------------------------------------------------------------
" vim: textwidth=0 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: foldmethod=marker
