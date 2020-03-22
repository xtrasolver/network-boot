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


wget https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz
tar -zxvf helm-v3.1.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml
kubectl get pods -n cert-manager -w

kubectl create namespace cattle-system
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=rancher.192.168.14.118.xip.io



curl -L https://github.com/rancher/cli/releases/download/v2.3.2/rancher-linux-amd64-v2.3.2.tar.gz -o rancher-linux-amd64-v2.3.2.tar.gz
tar -zxvf rancher-linux-amd64-v2.3.2.tar.gz
sudo mv rancher-v2.3.2/rancher /usr/local/bin/rancher


rancher login https://rancher.192.168.14.118.xip.io --token token-rh9ss:79jf72qgncs59tcjsd4m8pxdhftcgkb2zgvzf42vsttj242bc2pbq4 --skip-verify
rancher clusters create pokus --import
rancher cluster import pokus -q 2>/dev/null | grep "curl --insecure" | sh