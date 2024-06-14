# sharp-heic

This is a repository working on preparing AWS Lambda layer of Node.js library [sharp](https://github.com/lovell/sharp). The basic script is based on [this post](https://toshiro110.hatenablog.com/entry/2021/09/12/205439).

While sharp supports many image formats, it does not support .heic by default([sharp-libvips](https://github.com/lovell/sharp-libvips), as well as higher bit depth .avif file. This can be solved by make a local compiled version of [libvips](https://github.com/libvips/libvips), with [libheif](https://github.com/strukturag/libheif) compiled with [aom](https://aomedia.googlesource.com/aom/)(for .avif), [libde265](https://github.com/strukturag/libde265) and [kvazaar](https://github.com/ultravideo/kvazaar)(for .heif).

## Build
Environment requirement: Docker
```sh
chmod u+x make.sh
./make.sh
```
This script will build a docker image(The Dockerfile exists in docker/), which installs all the libraries needed and creates a sharp-layer.zip file. The script will then run the docker image in a new container, copy the layer file to build/, and then remove the container.

You can also download from [releases](https://github.com/CaoRX/sharp-heic/releases). Currently(1.0.0) the layer file is for arm64 architecture on Node.js 20.x runtime, so you can build your own layer if needed.

## Usage
To use this layer, you can create a AWS Lambda function under corresponding runtime(Node.js 20.x) and architecture(e.g. arm64). Then you need to upload this sharp-layer.zip as a layer, and append it to your function. A sample function may look like:
```javascript
import sharp from "sharp";
import { execSync } from 'child_process';
function myExec(command) {
  console.log(execSync(command).toString());
}

export const handler = async (event) => {
  await sharp('sample.heic').jpeg().toFile("/tmp/sample-heic.jpg");
  await sharp('sample.avif').jpeg().toFile("/tmp/sample-avif.jpg");
  await sharp('sample.png').jpeg().toFile("/tmp/sample-png.jpg");

  try {
    myExec("ls -l /tmp");
  } catch (err) {
    console.error("Error: ", err);
  }

  const response = {};
  return response;
}
```
and you can upload sample.heic/avif/png files to test the sharp library on these image formats.

## License
This library is under MIT License, but please confirm the licenses of the libraries used(sharp, libvips, libheif, libde256, kvazaar, aom...) if you use the layer to create lambda function.
