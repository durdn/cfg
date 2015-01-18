vim-gocode
==========

All credit goes to [nsf/code](http://github.com/nsf/gocode) and Go authors.
All Vim plugins from Go 1.2 are also included.

You should *not* install this plugin with either [fsouza/go.vim](https://github.com/fsouza/go.vim) or [jnwhiteh/vim-golang](https://github.com/jnwhiteh/vim-golang)! It could take unknown effect on your setup.
## Commands


* **:RelPkg** takes no or one argument, a relative package path, and prints it as a full package path. If no argument is given, default to current package.

*Example* `:RelPkg ../pkg/child` in the `$GOPATH/src/github.com/Blackrush/gofus/main.go` file will print `github.com/Blackrush/pkg/child`

* **:GoInstall** takes no or one argument, a relative package path, installs it or prints compilation errors otherwise. If no argument is given, default to current package.

*Example* `:GoInstall ../pkg/child` with current working directory `$GOPATH/src/github.com/Blackrush/gofus`
will try to install the `github.com/Blackrush/pkg/child` package

* **:GoTest** takes no or one argument, a relative package path, tests it and prints its output. If no argument is given, default to current package.

*Example* `:GoTest ../pkg/child` with current working directory `$GOPATH/src/github.com/Blackrush/gofus`
will try to test the `github.com/Blackrush/pkg/child` package

* **:GoImport**, **:GoImportAs** and **:GoDrop** are equivalent of original **:Import**, **:ImportAs** and **:Drop**
but takes all a relative package path to the current working directory

* **:make** — you can use QuickFix to iterate through build errors if any; if file is in subdirectory of $GOPATH/src/, the whole package is build, else — only current file

See [#1](https://github.com/Blackrush/vim-gocode/issues/1) to see future commands implementation.

## Installation

Make sure you have installed [gocode](https://github.com/nsf/gocode) before installing this plugin :

```bash
go get github.com/nsf/gocode
```

### Vundle

Add this line to your ~/.vimrc configuration file :

    Bundle 'Blackrush/vim-gocode'

And then run vim :

    vim +BundleInstall

### Pathogen

    cd ~/.vim/bundle
    git clone git@github.com:Blackrush/vim-gocode.git
