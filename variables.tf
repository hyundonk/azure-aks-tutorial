variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
    default = 2
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "hyukaks"
}

variable cluster_name {
    default = "hyukaks"
}

variable resource_group_name {
    default = "hyuk-k8stest"
}

variable location {
    default = "koreacentral"
}

variable log_analytics_workspace_name {
    default = "hyukakstestla"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "koreacentral"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
