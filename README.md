# Azure AKS Windows Container Tutorial

```
$ az --version
$ az extension add --name aks-preview
$ az extension update --name aks-preview

# Register WindowsPreview feature
$ az feature register --name WindowsPreview --namespace Microsoft.ContainerService

# check if registration state is "Registerred"
$ az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/WindowsPreview')].{Name:name,State:properties.state}"

# 
az provider register --namespace Microsoft.ContainerService

$ git clone https://github.com/hyundonk/azure-aks-tutorial.git
$ cd azure-aks-tutorial
$ terraform init
$ terraform apply

# get credentials to 
$ az aks get-credentials --resource-group hyuk-k8stest --name hyukaks

$ kubectl get nodes

$ kubectl apply -f sample.yaml

$ kubectl get service sample --watch

# Then using web browser access external IP for the sevice
```

### Storage Class on AKS
AKS는 Azure Disk를 이용하기 위한 두개의 storage class를 기본으로 제공 

$ kubectl get sc
NAME                 PROVISIONER                AGE
default (default)    kubernetes.io/azure-disk   13h
disk.csi.azure.com   disk.csi.azure.com         13m
managed-premium      kubernetes.io/azure-disk   13h

K8s v1.13 부터 K8s에서 CSI(Container Storage Interface)가 [GA](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/)되었음. CSI는 기존의 k8s main tree에서 관리하던 storage 시스템에 대한 지원 코드를 외부로 분리하여 storage 시스템 제조사가 해당 plug-in에 대한 유지 및 지원을 할 수 있도록 확장성을 제공.

Azure Disk에 대한 CSI plugin (disk.csi.azure.com)은 Microsoft가 https://github.com/kubernetes-sigs/azuredisk-csi-driver 를 통해 제공함

Azure Disk CSI plugin을 사용하는 방법은 
1) [AzureDisk CSI driver (CRDs 및 DaemonSet 등) 설치](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/install-azuredisk-csi-driver.md)
2) [Basic usage](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/deploy/example/e2e_usage.md)

Windows container의 경우 제약 사항 
 - "Privilieged" container를 구동할 수 없음 (DaemonSet). CSI plugin을 구동할 수 없음
 - Privileged Proxy 프로세스를 host에서 구동하여 지원. Container는 Named pipe를 통해 Provileged proxy에 Storage 기능을 요청.
 
 








