#!/bin/bash

set -e

if [ -z $RK1808_TOOL_CHAIN ]; then
  echo "Please set the RK1808_TOOL_CHAIN environment variable!"
  echo "example:"
  echo "  export RK1808_TOOL_CHAIN=<path-to-your-dir/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu>"
  exit
fi

# RK1808_TOOL_CHAIN="/home/xz/Documents/git_rk/compile_tools/1808/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu"

# for rk1808 aarch64
GCC_COMPILER=${RK1808_TOOL_CHAIN}/bin/aarch64-linux-gnu

ROOT_PWD=$( cd "$( dirname $0 )" && cd -P "$( dirname "$SOURCE" )" && pwd )

# model_zoo_path root path
MZ_ROOT=$(pwd | sed 's/\(rknn_model_zoo\).*/\1/g')

# build rockx
BUILD_DIR=${ROOT_PWD}/build

if [[ ! -d "${BUILD_DIR}" ]]; then
  mkdir -p ${BUILD_DIR}
fi

cd ${BUILD_DIR}
cmake .. \
    -DCMAKE_C_COMPILER=${GCC_COMPILER}-gcc \
    -DCMAKE_CXX_COMPILER=${GCC_COMPILER}-g++ \
    -DMZ_ROOT=${MZ_ROOT} \
    -DTARGET_SOC=RK1808 \
    -DCMAKE_SYSTEM_NAME=Linux
make -j4
make install
cd ..

cd ${BUILD_DIR}
cmake .. \
    -DCMAKE_C_COMPILER=${GCC_COMPILER}-gcc \
    -DCMAKE_CXX_COMPILER=${GCC_COMPILER}-g++ \
    -DMZ_ROOT=${MZ_ROOT} \
    -DTARGET_SOC=RK1808 \
    -DCMAKE_SYSTEM_NAME=Linux
make -j4
make install

