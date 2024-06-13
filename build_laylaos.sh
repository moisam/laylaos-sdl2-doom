#!/usr/bin/env bash

if [ "${CROSS_BUILD_SYSROOT}x" == "x" ]; then
    echo "Environment variable $$CROSS_BUILD_SYSROOT is not defined"
    echo "Did you forget to 'source prep_cross.sh'?"
    exit 1
fi

if [ "${CROSS_BUILD_ARCH}" == "x86_64" ]; then
    HOST="x86-64"
else
    HOST=${ARCH}
fi

cd src && make clean && make -j4 HOST=${HOST} && cp ./sdl2-doom ../sdl2-doom
make HOST=${HOST} install
cd ..

# copy the icon
mkdir -p ${CROSS_BUILD_SYSROOT}/usr/local/share/gui/icons/
cp doom.ico ${CROSS_BUILD_SYSROOT}/usr/local/share/gui/icons/

# create a desktop entry file
mkdir -p ${CROSS_BUILD_SYSROOT}/usr/local/share/gui/desktop/
cat > ${CROSS_BUILD_SYSROOT}/usr/local/share/gui/desktop/doom.entry << EOF
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

