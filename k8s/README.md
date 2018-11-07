# k8s deployment

```console
MBProEvensEPI:k8s evenssolignac$ terraform init
MBProEvensEPI:k8s evenssolignac$ terraform plan -out 1~
MBProEvensEPI:k8s evenssolignac$ terraform apply 1~
```

```console
sudo kubeadm init --pod-network-cidr=10.0.1.0/24 # corresponding to the network you want pods to run on
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

either `flannel`
```console
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl -n kube-system get deployment coredns -o yaml | \
  sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | \
  kubectl apply -f -

kubectl taint nodes --all node-role.kubernetes.io/master-

```

```console
kubectl get pods --all-namespaces
```