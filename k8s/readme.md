# install k3d


# configure k3d
## manual start
sudo mkdir -p /mnt/data/local-pv

sudo chmod 777 /mnt/data/local-pv

k3d cluster create mycluster --volume /mnt/data/local-pv:/mnt/data/local-pv

## service auto start
sudo nano /etc/systemd/system/k3d-cluster.service

mkdir -p ~/k8s-configs

cp storage-class.yaml persistent-volume.yaml persistent-volume-claim.yaml test-deployment.yaml ~/k8s-configs/

create a apply-config.sh file with crontab start up to bring all artifacts up running
