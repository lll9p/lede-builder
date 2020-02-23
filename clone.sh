#!/bin/bash
BUILD_PATH="/home/build"
echo 'Clone lede.'
echo ''
if [[ ! -d ${HOME}/build/lll9p/lede-builder/lede ]]; then
    git clone https://github.com/coolsnowwolf/lede
fi

echo 'Clone serverchan.'
echo ''
if [[ ! -d ${HOME}/build/lll9p/lede-builder/luci-app-serverchan ]]; then
    git clone https://github.com/tty228/luci-app-serverchan
fi

