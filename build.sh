#!/bin/bash
BUILD_PATH="/home/build"
echo 'Clone lede.'
echo ''
ls ${BUILD_PATH} -al
if [[ ! -d ${BUILD_PATH}/lede ]]; then
    git clone https://github.com/coolsnowwolf/lede
fi

echo 'Clone serverchan.'
echo ''
if [[ ! -d ${BUILD_PATH}/luci-app-serverchan ]]; then
    git clone https://github.com/tty228/luci-app-serverchan
fi

echo '--- Pull from lede. ---'
cd ${BUILD_PATH}/lede
git pull
git status
echo '--- Pull from luci-app-serverchan. ---'
cd ${BUILD_PATH}/luci-app-serverchan
git pull
echo ''
echo '--- Add luci-app-serverchan to package. ---'
echo ''
if [ ! -f ${BUILD_PATH}/lede/package/feeds/luci/luci-app-serverchan ]; then
    mkdir -p ${BUILD_PATH}/lede/package/feeds/luci
    ln -s ${BUILD_PATH}/luci-app-serverchan ${BUILD_PATH}/lede/package/feeds/luci/luci-app-serverchan
fi

echo ''
echo '--- Update feeds. ---'
echo ''
${BUILD_PATH}/lede/scripts/feeds update -a && ${BUILD_PATH}/lede/scripts/feeds install -a

echo '--- Remove tmp files. ---'
if [ -d ${BUILD_PATH}/lede/tmp ]; then
    rm -rf ${BUILD_PATH}/lede/tmp
fi

echo '--- Remove tmp old config. ---'
rm -rf ${BUILD_PATH}/lede/.config

echo '--- Using diff config file. ---'
cp ${BUILD_PATH}/diffconfig ${BUILD_PATH}/lede/.config

echo '--- Expand to full config file. ---'
cd ${BUILD_PATH}/lede
pwd
make defconfig

echo '--- Download needed files. ---'
make download 2>&1 | tee ${BUILD_PATH}/build.log

echo '--- Start build. ---'
make -j5 V=s 2>&1 | tee build.log
if [ -f ${BUILD_PATH}/lede/build.log ]; then
    rm ${BUILD_PATH}/lede/build.log
fi
rm -rf ${BUILD_PATH}/lede/.config
#rm -rf ${BUILD_PATH}/lede/luci-app-serverchan
