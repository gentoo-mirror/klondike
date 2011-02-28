#!/bin/bash
#set -x
if [ ! -d ~/.bpmdj ]; then
        # create needed directories
        mkdir -p  ~/.bpmdj/fragments
        mkdir -p  ~/.bpmdj/index
        mkdir -p  ~/.bpmdj/music
        # link application to user-directory
        ln -sf /usr/share/bpmdj/sequences ~/.bpmdj
fi

(cd ~/.bpmdj && bpmdj_orig)
