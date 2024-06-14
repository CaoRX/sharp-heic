# !/bin/bash

yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs zip

yum install git -y
yum install cmake gobject-introspection meson -y
yum install automake libtool -y
yum install zlib-devel zlib-static -y
yum install glib2-devel -y
yum install expat-devel -y
yum install lcms2-devel libjpeg-turbo-devel -y
yum install libpng-devel -y

# install libde265
cd /tmp
git clone https://github.com/strukturag/libde265.git
cd libde265/
./autogen.sh
./configure
make
make install

# install x265
# x265 is GPL licensed, instead we will use kvazaar(BSD licensed) as a replacement
# cd /tmp
# git clone https://github.com/videolan/x265.git
# cd x265/build
# cmake ../source
# make
# make install

# install kvazaar
cd /tmp
git clone https://github.com/ultravideo/kvazaar
cd kvazaar
./autogen.sh
./configure
make
make install

# install aom
cd /tmp
git clone https://aomedia.googlesource.com/aom
cd aom/build
# cmake -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" ..
cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" ..
make
make install

# set environment variables to make newly installed libde265 and x265 work
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# install libheif(with libde265 and x265)
cd /tmp
git clone https://github.com/strukturag/libheif.git
cd libheif
mkdir build
cd build
cmake --preset=release ..
make
make install

# set environment variables to make newly installed libheif work
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH

# install libvips
cd /tmp
curl -LO https://github.com/libvips/libvips/archive/refs/tags/v8.15.2.tar.gz
tar -zxf v8.15.2.tar.gz
cd libvips-8.15.2
# meson setup build --prefix /tmp/libvips-build/build
meson setup build --prefix /opt --libdir lib/
cd build
meson compile
meson test
meson install

# set environment variables to make newly installed libvips work
export PKG_CONFIG_PATH=/opt/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/opt/lib:$LD_LIBRARY_PATH
export PATH=/opt/bin:$PATH

# force sharp to use newly installed libvips(not work however)
export SHARP_FORCE_GLOBAL_LIBVIPS=true
cd /var/task
npm install sharp

# remove libvips binding, to use the newly installed libvips(with libheif support)
mv /var/task/node_modules/@img/sharp-libvips-linux-arm64/lib/libvips-cpp.so.42 /var/task/node_modules/@img/sharp-libvips-linux-arm64/lib/libvips-cpp.so.42.bak