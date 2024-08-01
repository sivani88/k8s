variable "location" {
  type        = string
  default     = "west europe"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "sc-kubernetes-build"
  description = "the resource group name"
}
