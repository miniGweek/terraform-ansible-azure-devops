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


  backendresourcegroupname = "learn-terraform-auea-rg"

  prefix     = "lrn-dvops-${local.location.shortname}"
  prefixcore = "${local.prefix}-core"
}
