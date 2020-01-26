resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.k8s.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.k8s.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_virtual_network" "vnet" {

	name                = "myvnet"
	location 			        = azurerm_resource_group.k8s.location
	resource_group_name		= azurerm_resource_group.k8s.name
	address_space         = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "ext" {
	name                    	= "external"
	resource_group_name		    = azurerm_resource_group.k8s.name
	virtual_network_name    	= azurerm_virtual_network.vnet.name
	address_prefix          	= "10.20.0.0/24"
}

/*
resource "azurerm_network_security_group" "ext" {
	name                  = "nsg-external"
	location 			        = azurerm_resource_group.k8s.location
	resource_group_name		= azurerm_resource_group.k8s.name
}

resource "azurerm_subnet_network_security_group_association" "ext" {
  subnet_id                 = "${azurerm_subnet.ext.id}"
  network_security_group_id = "${azurerm_network_security_group.ext.id}"
}
resource "azurerm_subnet" "int" {
	name                    	= "internal"
	resource_group_name		    = azurerm_resource_group.k8s.name
	virtual_network_name    	= azurerm_virtual_network.vnet.name
	address_prefix          	= "10.20.1.0/24"
}

resource "azurerm_network_security_group" "int" {
	name                  = "nsg-internal"
	location 			        = azurerm_resource_group.k8s.location
	resource_group_name		= azurerm_resource_group.k8s.name
}

resource "azurerm_subnet_network_security_group_association" "int" {
  subnet_id                 = "${azurerm_subnet.int.id}"
  network_security_group_id = "${azurerm_network_security_group.int.id}"
}
*/

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    kubernetes_version = "1.14.8"
    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_DS1_v2"
        type            = "VirtualMachineScaleSets"
        vnet_subnet_id  = azurerm_subnet.ext.id
    }

    network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard" 
    }

    windows_profile {
      admin_username = "azureuser"
      admin_password = "Passw0rd!123"
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
        }
    }

    tags = {
        Environment = "Development"
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "win_node_pool" {
  name                  = "winnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_D4s_v3"
  os_type               = "Windows"
  vnet_subnet_id        = azurerm_subnet.ext.id
  node_count            = 2
}
