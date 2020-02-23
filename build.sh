#!/bin/bash
BUILD_PATH="/home/build"
PROXYCHAINS="proxychains4 -q "
echo 'Start build script.'
echo ''
echo '--- Modify proxychains configs. ---'
sudo sed -i '$ d' /etc/proxychains4.conf
sudo sed -i '$ d' /etc/proxychains4.conf
echo 'socks5 172.17.0.1 1081' | sudo tee -a /etc/proxychains4.conf
echo '' | sudo tee -a /etc/proxychains4.conf

echo '--- Pull from git server. ---'
echo ''
echo '--- Pull from lede. ---'
cd ${BUILD_PATH}/lede
${PROXYCHAINS} git pull
echo '--- Pull from luci-app-serverchan. ---'
cd ${BUILD_PATH}/luci-app-serverchan
${PROXYCHAINS} git pull
echo ''
echo '--- Add luci-app-serverchan to package. ---'
echo ''
cd ${BUILD_PATH}/lede
rm ${BUILD_PATH}/lede/package/feeds/luci/luci-app-serverchan
ln -s ${BUILD_PATH}/luci-app-serverchan ${BUILD_PATH}/lede/package/feeds/luci/luci-app-serverchan
${PROXYCHAINS} ${BUILD_PATH}/lede/scripts/feeds update -a && ${BUILD_PATH}/lede/scripts/feeds install -a

echo '--- Remove tmp files. ---'
rm -rf ${BUILD_PATH}/lede/tmp

echo '--- Remove tmp old config. ---'
rm -rf ${BUILD_PATH}/lede/.config

echo '--- Using diff config file. ---'
cp ${BUILD_PATH}/diffconfig ${BUILD_PATH}/lede/.config

echo '--- Expand to full config file. ---'
make defconfig

echo '--- Download needed files. ---'
${PROXYCHAINS} make download

echo '--- Start build. ---'
make -j5 V=s
