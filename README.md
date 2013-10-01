vim-slim
===

slim syntax highlighting for vim.

1. Install pathogen (if you haven't already)

        mkdir -p ~/.vim/autoload ~/.vim/bundle; \
        curl -so ~/.vim/autoload/pathogen.vim \
          https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

2. Edit `~/.vimrc` to run pathogen as the first line of the file (if you haven't already)

        call pathogen#infect()

3. Install slim-vim

        pushd ~/.vim/bundle; \
        git clone git@github.com:slim-template/vim-slim.git; \
        popd
