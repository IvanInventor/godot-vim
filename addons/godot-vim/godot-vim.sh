#!/bin/bash

TERM_PATH=$1
PWD=$2
FILENAME=$(realpath --relative-to="$2" "$3") # TODO: filename without path as tab name
LINE=$4
COL=$5

SOCKET_NAME="/tmp/godot-vim.$PPID"
which wmctrl 2>/dev/null && FOCUS_CMD='wmctrl -ia $WINDOWID'

if [ -S "$SOCKET_NAME" ]; then
	vim --server "$SOCKET_NAME" --remote-tab "$FILENAME"
	vim --server "$SOCKET_NAME" --remote-expr "cursor($LINE,$COL)"
	[ -v "FOCUS_CMD" ] && vim --server "$SOCKET_NAME" --remote-expr "system('$FOCUS_CMD')"
else
	$TERM_PATH -e vim --listen "$SOCKET_NAME" "+call cursor($LINE,$COL)" -- "$FILENAME"
fi

