variable "resource_group_name" {
  description = "The name of the existing resource group."
  type        = string
  default     = "sc-kubernetes-build"
}

variable "location" {
  description = "The location of the resources."
  type        = string
  default     = "westeurope"
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "vnet-kubernetes"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = string
  default     = "172.59.0.0/16"
}


variable "environment" {
  description = "The environment tag for the resources."
  type        = string
  default     = "kubernetes"
}
