#!/usr/bin/env bash

if [ "${CROSSCOMPILE_SYSROOT_PATH}x" == "x" ]; then
    echo "$0: Environment variable \$CROSSCOMPILE_SYSROOT_PATH is not defined"
    echo "$0: Bailing out"
    exit 1
fi

cd src && make clean && make -j4 && cp ./sdl2-doom ../sdl2-doom
make install
cd ..

# copy the icon
mkdir -p ${CROSSCOMPILE_SYSROOT_PATH}/usr/share/gui/icons/
cp doom.ico ${CROSSCOMPILE_SYSROOT_PATH}/usr/share/gui/icons/

# create a desktop entry file
mkdir -p ${CROSSCOMPILE_SYSROOT_PATH}/usr/share/gui/desktop/
cat > ${CROSSCOMPILE_SYSROOT_PATH}/usr/share/gui/desktop/doom.entry << EOF
#
# Desktop entry file
#

[Desktop Entry]
Name=Doom
Command=/usr/bin/sdl2-doom
IconPath=Default
Icon=doom
ShowOnDesktop=no
Category=Games

EOF

