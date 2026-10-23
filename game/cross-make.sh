#!/bin/sh

PREFIX=$GP2XDEV
TARGET=gp2x
PATH="$PREFIX/bin:$PREFIX/$TARGET/bin:$PATH"
export PATH
exec make $*
