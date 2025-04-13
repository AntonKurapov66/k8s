variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "default_zone" {
  type        = string
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "ssh_public_key_path" {
  type        = string
}

variable "service_account_key_file" {
  type        = string
}

variable "existing_sa_id" {
  default = "ajeg0gva2hkqevrdotfm" 
}
