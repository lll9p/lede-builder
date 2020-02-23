#!/bin/bash
BUILD_PATH="/home/build"
echo 'Clone lede.'
echo ''
[[ ! -d ${HOME}/build/lll9p/lede-builder/lede ]] && git clone https://github.com/coolsnowwolf/lede

echo 'Clone serverchan.'
echo ''
[[ ! -d ${HOME}/build/lll9p/lede-builder/luci-app-serverchan ]] && git clone https://github.com/tty228/luci-app-serverchan

