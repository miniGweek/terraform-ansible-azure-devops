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

  naming_prefix     = "learn-ansible-${local.location.shortname}"
  resourcegroupname = "learn-terraform-auea-rg"
}