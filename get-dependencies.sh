#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake           \
    cups            \
    mariadb-libs    \
    postgresql-libs \
    unixodbc

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2
make-aur-package qt4
#PRE_BUILD_CMDS="export CXXFLAGS=\"\$CXXFLAGS -fpermissive\"" make-aur-package qt4

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Glypha..."
echo "---------------------------------------------------------------"
REPO="https://github.com/kainjow/Glypha"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./Glypha
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Glypha
make qt -j$(nproc)
mv -v "build/Glypha III" ../AppDir/bin
