#!/bin/bash

PWD=$1
FILENAME=$2
LINE=$3
COL=$4

SOCKET_NAME="/tmp/godot-vim.$PPID"

if [ -S "$SOCKET_NAME" ]; then
	vim --server "$SOCKET_NAME" --remote-tab "$FILENAME"
	vim --server "$SOCKET_NAME" --remote-expr "cursor($LINE,$COL)"
	vim --server "$SOCKET_NAME" --remote-expr 'system("wmctrl -ia $WINDOWID")'
else
	alacritty -e vim --listen "$SOCKET_NAME" "+call cursor($LINE,$COL)" -- "$FILENAME"
fi

