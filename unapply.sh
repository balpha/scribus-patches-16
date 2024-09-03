#!/bin/bash
set -e

CODEDIR=$(cat scribusdir.txt) # you must create this
DIR=$( pwd )

tac list.txt | while read L; do
	pushd $CODEDIR > /dev/null
	echo "### $L ###"
	patch -p0 --reverse < "$DIR/$L"
	popd > /dev/null
done
