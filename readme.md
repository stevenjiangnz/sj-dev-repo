# To start minikube, run
minikube start --driver=docker

# in order to map the local folder to pv
minikube mount /mnt/data/k8s:/mnt/data/k8s

note: a terminal is required to keep open in order to map the host folder and minikube pv

this should not trigger python 124
