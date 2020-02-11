##############################################################################
# Sensitive Account Variables
##############################################################################

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

##############################################################################


##############################################################################
# Account Variables
##############################################################################

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "us-south"
}

variable resource_group {
  description = "Name of resource group to provision resources"
  default     = "default"
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable vpc_name {
  description = "ID of VPC where cluster is to be created"
}

variable subnet_ids {
  description = "List of subnet ids. Can be used to create 1, 2, or 3 zone IKS on VPC clusters"
  type        = "list"
}


##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_name {
  description = "name for the iks cluster"
}

variable machine_type {
  description = "Machine type for the IKS Cluster"
  default     = "b2.4x16"
}


variable worker_count {
  description = "Number of workers per zone"
  default     = 2
}

variable disable_pse {
  description = "Disable public service endpoint for cluster. True or false"
  default     = false
}

variable enable_albs {
  description = "Enable ALBs for cluster"
  default     = true
}

variable only_private_albs {
  description = "enable only private albs"
  default     = false
}

##############################################################################