#!/usr/bin/env bash

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [ -x ~/neofetch/neofetch ]; then
	~/neofetch/neofetch
fi
