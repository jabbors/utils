#!/bin/bash

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)

# setup bash
echo "setting up bash_aliases"
test -L ~/.bash_aliases && echo "already setup"
test -L ~/.bash_aliases || ln -s $SCRIPTPATH/bash/bash_aliases/ ~/.bash_aliases
echo "setting up bash_profile"
test -L ~/.bash_profile && echo "already setup"
test -L ~/.bash_profile || ln -s $SCRIPTPATH/bash/bash_profile ~/.bash_profile

# setup git
echo "setting up git"
test -L ~/.gitconfig && echo "already setup"
test -L ~/.gitconfig || ln -s $SCRIPTPATH/git/gitconfig ~/.gitconfig

# setup puppet-lint
echo "setting up puppet-lint.rc"
test -L ~/.puppet-lint.rc && echo "already setup"
test -L ~/.puppet-lint.rc || ln -s $SCRIPTPATH/puppet-lint/puppet-lint.rc ~/.puppet-lint.rc

# setup vim
echo "setting up vim"
test -L ~/.vim && echo "already setup"
test -L ~/.vim || ln -s $SCRIPTPATH/vim/ ~/.vim
echo "setting up vimrc"
test -L ~/.vimrc && echo "already setup"
test -L ~/.vimrc || ln -s $SCRIPTPATH/vim/vimrc ~/.vimrc

# setup z
echo "setting up z"
test -L ~/.z.sh && echo "already setup"
test -L ~/.z.sh || ln -s $SCRIPTPATH/z/z.sh ~/.z.sh
