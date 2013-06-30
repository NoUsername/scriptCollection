#!/bin/bash

# make sure we're in the folder the script is stored in
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

echo installing .bashrc_ext
if [ -f $HOME/.bashrc ]; then
	cp $HOME/.bashrc $HOME/.bashrc.bak
fi
if [ -f $HOME/.bashrc_ext ]; then
	mv $HOME/.bashrc_ext $HOME/.bashrc_ext.bak
fi
cp bash/bashrc_ext $HOME/.bashrc_ext

# check if our bashrc_ext script is already included in .bashrc
cat $HOME/.bashrc | grep .bashrc_ext > /dev/null 2>&1
if [ "$?" != "0" ]; then
	printf "\n\nif [ -f ~/.bashrc_ext ]; then\n    . ~/.bashrc_ext\nfi\n\n" >> $HOME/.bashrc
fi

echo installing .tmux.conf
if [ -f $HOME/.tmux.conf ]; then
	mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
fi
cp conf/tmux.conf $HOME/.tmux.conf

echo installing shellscripts to /scripts/
mkdir -p $HOME/scripts

# copy a script to ~/scripts/ making backups of existing files
SCRIPTNAME="script.sh"
copyScriptSafe() {
	if [ -f $HOME/scripts/$SCRIPTNAME ]; then
		mv $HOME/scripts/$SCRIPTNAME $HOME/scripts/${SCRIPTNAME}.bak
	fi
	cp bash/$SCRIPTNAME $HOME/scripts/
}

SCRIPTNAME="backupDb.sh"
copyScriptSafe

cp bash/backupDb.sh $HOME/scripts/

