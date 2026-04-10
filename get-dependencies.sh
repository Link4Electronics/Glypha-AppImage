#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake qt5-multimedia

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building Glypha..."
echo "---------------------------------------------------------------"
REPO="https://github.com/kainjow/Glypha"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./Glypha
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./Glypha -B build -DHAVE_QT=true -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build --config Release -j$(nproc)
mv -v "build/Glypha III" ./AppDir/bin/Glypha
