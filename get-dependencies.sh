#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
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

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Glypha..."
echo "---------------------------------------------------------------"
git clone https://github.com/kainjow/Glypha ./Glypha
git rev-parse --short HEAD > ~/version
cd ./Glypha
make qt -j$(nproc)
cd build && ls
mv -v
