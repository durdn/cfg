"------------------------------------------------------------------------------
"  Description: Rainbow colors for parenthsis
"          $Id: rainbow_parenthsis.vim 29 2007-09-24 11:40:36Z krischik@users.sourceforge.net $
"    Copyright: Copyright (C) 2006 Martin Krischik
"   Maintainer: Martin Krischik
"               John Gilmore
"      $Author: krischik@users.sourceforge.net $
"        $Date: 2007-09-24 13:40:36 +0200 (Mo, 24 Sep 2007) $
"      Version: 4.0
"    $Revision: 29 $
"     $HeadURL: https://vim-scripts.googlecode.com/svn/trunk/1561%20Rainbow%20Parenthsis%20Bundle/plugin/rainbow_parenthsis.vim $
"      History: 24.05.2006 MK Unified Headers
"               15.10.2006 MK Bram's suggestion for runtime integration
"               06.09.2007 LH Buffer friendly (can be used in different buffers),
"                             can be toggled
"               09.09.2007 MK Use on LH's suggestion but use autoload to
"                             impove memory consumtion and startup performance
"               09.10.2007 MK Now with round, square brackets, curly and angle
"                             brackets.
"        Usage: copy to plugin directory.
"------------------------------------------------------------------------------
" This is a simple script. It extends the syntax highlighting to
" highlight each matching set of parens in different colors, to make
" it visually obvious what matches which.
"
" Obviously, most useful when working with lisp or Ada. But it's also nice other
" times.
"------------------------------------------------------------------------------

command! -nargs=0 ToggleRaibowParenthesis call rainbow_parenthsis#Toggle()

finish

"------------------------------------------------------------------------------
"   Copyright (C) 2006  Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence details.
"------------------------------------------------------------------------------
" vim: textwidth=78 wrap tabstop=8 shiftwidth=4 softtabstop=4 expandtab
" vim: filetype=vim foldmethod=marker
