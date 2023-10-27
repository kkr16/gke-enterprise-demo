variable "project_id" {
  description = "project id"
  type        = string
}

# variable "regions" {
#   type = list(object({
#     region_id   = string
#     region_name = string
#     subnet_cidr = string
#     master_ipv4_cidr_block = string
#   }))
# }

variable "regions" {
  type = map(object({
    region_name            = string
    subnet_cidr            = string
    master_ipv4_cidr_block = string
  }))
}
