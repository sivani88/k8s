variable "location" {
  description = "The Azure location where resources will be deployed"
  default     = "West europe"
}


variable "resource_group_name" {
  description = "The name of the existing resource group"
  default     = "sc-kubernetes-build"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  default     = "vnet-kubernetes"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet"
  default     = "vm-subnet"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  default     = "Standard_F2"
}

variable "admin_username" {
  description = "The admin username for the VM"
  default     = "adminuser"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    environment = "master"
    app         = "linux"
  }
}
