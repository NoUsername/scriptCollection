#!/bin/bash

# make sure we're in the folder the script is stored in
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

if [ -f $HOME/.bashrc ]; then
	mv $HOME/.bashrc $HOME/.bashrc.bak
fi
cp bash/bashrc $HOME/.bashrc


if [ -f $HOME/.tmux.conf.bak ]; then
	cp $HOME/.tmux.conf.bak $HOME/.tmux.conf
fi