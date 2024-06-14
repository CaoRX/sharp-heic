docker build -t sharp-heic docker/
docker run -it -d --name sharp-heic sharp-heic

mkdir build
cd build
docker cp sharp-heic:/var/sharp/sharp-layer.zip .

docker stop sharp-heic
docker rm sharp-heic