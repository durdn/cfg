# Writing Syntax for Vim

Bundle for vim to highlight adjectives, passive language and weasel words.

<a href="http://imgur.com/5LJYy6t"><img src="http://i.imgur.com/5LJYy6t.png" title="Hosted by imgur.com"/></a>
## Overview

This project is inspired by the article [Shell scripts for passive voice, weasel words, and duplicates](http://matt.might.net/articles/shell-scripts-for-passive-voice-weasel-words-duplicates/) by [Matt Might](https://twitter.com/mattmight). There have been other vim implementations ([see here](https://github.com/davidbeckingsale/writegood.vim)) but they didn't use a syntax file or address adjective overuse. 

## Installation

- Install with [Vundle](https://github.com/gmarik/vundle)

If you are not using vundle, you really should have a try.
Edit your vimrc:

    Bundle "jamestomasino/vim-writingsyntax"

And install it:

    :so ~/.vimrc
    :BundleInstall


- Install with [pathogen](https://github.com/tpope/vim-pathogen)

If you prefer tpope's pathogen, that's ok. Just clone it:

    cd ~/.vim/bundle
    git clone https://github.com/jamestomasino/vim-writingsyntax.git

## Use

To enable the highlighting:

    :setf writing


## License

This project uses data from WordNet, so I'm including their license below.

Princeton University "About WordNet." WordNet. Princeton University. 2010. <http://wordnet.princeton.edu>

WordNet Release 3.0 This software and database is being provided to you, the LICENSEE, by Princeton University under the following license. By obtaining, using and/or copying this software and database, you agree that you have read, understood, and will comply with these terms and conditions.: Permission to use, copy, modify and distribute this software and database and its documentation for any purpose and without fee or royalty is hereby granted, provided that you agree to comply with the following copyright notice and statements, including the disclaimer, and that the same appear on ALL copies of the software, database and documentation, including modifications that you make for internal use or for distribution. WordNet 3.0 Copyright 2006 by Princeton University. All rights reserved. THIS SOFTWARE AND DATABASE IS PROVIDED "AS IS" AND PRINCETON UNIVERSITY MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED. BY WAY OF EXAMPLE, BUT NOT LIMITATION, PRINCETON UNIVERSITY MAKES NO REPRESENTATIONS OR WARRANTIES OF MERCHANT- ABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THE LICENSED SOFTWARE, DATABASE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS. The name of Princeton University or Princeton may not be used in advertising or publicity pertaining to distribution of the software and/or database. Title to copyright in this software, database and any associated documentation shall at all times remain with Princeton University and LICENSEE agrees to preserve same.

## Bug report

Report a bug on [GitHub Issues](https://github.com/jamestomasino/vim-writingsyntax/issues).
