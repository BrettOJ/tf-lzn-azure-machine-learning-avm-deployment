variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "southeastasia"

}

variable "enable_telemetry" {
  description = "Enable telemetry for the module."
  type        = bool
  default     = false
}

variable "create_compute_instance" {
  description = "Flag to create a compute instance."
  type        = bool
  default     = true
}

variable "ci_name" {
  description = "The name of the compute instance."
  type        = string
  default     = "boj002"
}