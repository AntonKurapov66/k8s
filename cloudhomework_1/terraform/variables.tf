variable "cloud_id" {
  type        = string
  default     = "b1gm0sekm569kfleabus"
}

variable "folder_id" {
  type        = string
  default     = "b1giaqsjeldr7t9a91bv"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "ssh_public_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0mwrKQZhw3KB8E8yzFP1fVLP8xM8TnsylF/VUiJJMp cloudoperator@mulo.com"
}