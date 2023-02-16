#!/bin/bash

set -e

#========================= options ========================#

BUILD_TYPE="Release"
FLAG_INSTALL=NO

#========================== usage =========================#

print_usage() {
    echo "[options]"
    echo "-t|--type         Built Type"
    echo "                  Release"
    echo "                  Debug"
    echo "-i                Install or not"

    echo "[example]"
    echo "./build.sh -t Debug"
    exit 1
}

#===================== parse arguments ====================#

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -t|--type)
        BUILD_TYPE=$2
        shift
        shift
        ;;

        -i)
        FLAG_INSTALL=YES
        shift
        ;;

        *)
        POSITIONAL+=("$key")
        shift
        ;;
    esac
done

echo "Build Type:           ${BUILD_TYPE}"

#========================= detect =========================#

#---------------------------- OS --------------------------#

OS="windows"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
fi

#------------------------ directories ---------------------#

SCRIPT_DIR="$( cd $(dirname $0) && pwd -P )"
PROJECT_DIR="$( cd $(dirname $0)/.. && pwd -P )"
BUILD_DIR="${PROJECT_DIR}/build"

#====================== configuration =====================#

VS_GEN=(-G "Visual Studio 16 2019" -A x64)

#========================= build ==========================#

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

if [[ "$OS" == "windows" ]]; then
    conan install .. -s build_type=${BUILD_TYPE}
    cmake .. "${VS_GEN[@]}" \
        -DCMAKE_BUILD_TYPE=$BUILD_TYPE
    cmake --build . --config ${BUILD_TYPE} -j8
    if [[ "$FLAG_INSTALL" == "YES" ]]; then
        cmake --install . --config ${BUILD_TYPE}
    fi
fi
