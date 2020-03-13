docker build -t xtrasolver/ipxe-tftp-server:latest .\ipxe-tftp-server
docker build -t xtrasolver/ipxe-web-server:latest  .\ipxe-web-server


docker-compose up -d

docker-compose down

docker push xtrasolver/tftp-server:latest
docker push xtrasolver/ipxe-web-server:latest

docker cp network-boot_tftp-server_1:/var/tftpboot/undionly.kpxe .\volume-data

id=$(docker create image-name)
docker cp $id:path - > local-tar-file
docker rm -v $id


docker run -p 69:69/udp xtrasolver/tftp-server:latest

docker run -p 0.0.0.0:69:69/udp -v ./volume-data:/var/tftpboot -i -t pghalliday/tftp