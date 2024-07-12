variable "bastion_configs" {
  description = "Configuration files for bastion"
}

variable "sg_configs" {
  description = "Configuration for Bastion's Security Groups"
}

variable "bastion_host_policy" {
  type = object({
    managed_policy_arns = list(string)
    inline_policy       = map(any)
  })
}
