#!/bin/bash

# wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-13.0.0_r83/clang-r450784d.tar.gz
# git clone https://github.com/xiangfeidexiaohuo/Snapdragon-LLVM.git /opt/Snapdragon-clang
# git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 /opt/aarch64-linux-android-4.9
# git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 /opt/arm-linux-androideabi-4.9

CLANG=/opt/clang-r450784d/bin
GCC32=/opt/arm-linux-androideabi-4.9/bin
GCC64=/opt/aarch64-linux-android-4.9/bin


export CLANG_TRIPLE=aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-
PATH=$CLANG:$GCC64:$GCC32:$PATH
export PATH


# Vars
export HEADER_ARCH=$ARCH
export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=nobody
export KBUILD_BUILD_HOST=android-build

DATE_START=$(date +"%s")
echo "-------------------"
echo "Making Kernel:"
echo "-------------------"
echo

rm -rf out
make clean && make ARCH=arm64 mrproper
make -j$(nproc --all) CC=clang O=out LLVM=1 ARCH=arm64 O=out vendor/lahaina-qgki_defconfig vendor/lineage_moto-lahaina.config vendor/lineage_berlna.config

make -j$(nproc --all) CC=clang O=out LLVM=1 ARCH=arm64 CONFIG_LOCALVERSION_AUTO=n LOCALVERSION=-moto-g3d632fc45b76


echo
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
