#!/bin/bash
BUILD_PATH="/home/build"
echo 'Start build script.'
echo ''

echo '--- Pull from git server. ---'
echo ''

echo '--- Pull from lede. ---'
cd ${BUILD_PATH}/lede
git pull
echo '--- Pull from luci-app-serverchan. ---'
cd ${BUILD_PATH}/luci-app-serverchan
git pull
echo ''
echo '--- Add luci-app-serverchan to package. ---'
echo ''
if [ ! -f ${BUILD_PATH}/lede/package/feeds/luci/luci-app-serverchan ]; then
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
make defconfig

echo '--- Download needed files. ---'
make download

echo '--- Start build. ---'
make -j5 V=s
