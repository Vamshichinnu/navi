variable "instance_type" {
  description = "Instance type for primary and replica nodes"
  type        = string
}

variable "pg_version" {
  description = "PostgreSQL version"
  type        = string
}

variable "max_connections" {
  description = "Max connections for PostgreSQL"
  type        = number
}

variable "shared_buffers" {
  description = "Shared buffers for PostgreSQL"
  type        = string
}

variable "num_replicas" {
  description = "Number of replicas"
  type        = number
}
