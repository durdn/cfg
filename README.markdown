## textobj-word-column.vim

The word-based column text-object makes operating on columns of code
conceptually simpler and reduces keystrokes.

![textobj-word-column][1]

The common task of deleting, changing, or adding to a vertical column of code
can be achieved using visual-blocks, however the first step is to establish
the visual block itself.  This typically involves moving the cursor to the
start of the block, and then using vim motions to move the cursor to the end of
the block, and finally doing the appropriate operation.

With a text object for columns, establishing the visual block is much easier,
and even unecessary for certain operations.

### Usage

This plugin adds `ic`, `ac`, `iC`, and `aC` as text-objects.  Use them in
commands like `vic`, `cic`, and `daC`.

### Learn more in the plugin doc:

https://github.com/coderifous/textobj-word-column.vim/blob/master/doc/textobj-word-column.txt

[1]: http://i.imgur.com/AAgM9.gif
