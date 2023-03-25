#!/bin/bash

PWD=$1
FILENAME=$(realpath --relative-to="$1" "$2") # TODO: filename without path as tab name
LINE=$3
COL=$4

SOCKET_NAME="/tmp/godot-vim.$PPID"
FOCUS_CMD='wmctrl -ia $WINDOWID'

if [ -S "$SOCKET_NAME" ]; then
	vim --server "$SOCKET_NAME" --remote-tab "$FILENAME"
	vim --server "$SOCKET_NAME" --remote-expr "cursor($LINE,$COL)"
	vim --server "$SOCKET_NAME" --remote-expr "system('$FOCUS_CMD')"
else
	alacritty -e vim --listen "$SOCKET_NAME" "+call cursor($LINE,$COL)" -- "$FILENAME"
fi

