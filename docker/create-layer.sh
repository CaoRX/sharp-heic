cd /var
rm -rf sharp
mkdir sharp
cd sharp

mkdir nodejs
mkdir lib

cd nodejs
cp -r /var/task/* .
rm -f index.js sample* work.sh

cd ../lib
cp -r /usr/local/lib/libde265.so* .
cp -r /usr/lib64/libdw* .
cp -r /usr/lib64/libelf* .
cp -r /usr/lib64/libexpat* .
cp -r /usr/lib64/libgomp* .
cp -r /usr/local/lib64/libheif* .
cp -r /usr/local/lib64/libaom.so* .
cp -r /usr/lib64/libjpeg* .
cp -r /usr/lib64/liblcms* .
cp -r /opt/lib/libvips* .
cp -r /usr/local/lib/libkvazaar.so* .
cp -r /opt/lib/vips-modules* .
cp -r /lib64/libpng16* .

cd ..
zip -r sharp-layer.zip lib nodejs
