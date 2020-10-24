locals {

  location = {
    "fullname" : "Australia East"
    "shortname" : "auea"
  }

  tags = {
    "Owner" : "Rahul Sarkar"
    "Project" : "Learn"
    "Technology" : "DevOps-Ansible"
  }

  tags_dev = {
    "Environment" : "Development"
  }


  prefix     = "lrn-dvops-${local.location.shortname}"
  prefixcore = "${local.prefix}-core"
  prefixdev  = "${local.prefix}-dev"

  backendresourcegroupname = "learn-terraform-auea-rg"

  secret_keyvault_name = "lrn-dvops-auea-core-kv"
  secret_vm_login      = "vm--login"
  secret_vm_password   = "vm--password"

  core_rg              = "lrn-dvops-auea-core-rg"
  core_vnet            = "lrn-dvops-auea-core-vnet"
  core_internal_subnet = "lrn-dvops-auea-core-internal-snet"
}
