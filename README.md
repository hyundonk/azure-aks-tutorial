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
