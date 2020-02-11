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

variable generation {
  description = "Generation of VPC architecture. Currently IKS is only available in gen 1"
  default     = 1
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable vpc_name {
  description = "Name of VPC where cluster is to be created"
}

variable subnet_ids {
  description = "List of subnet IDs [zone 1, zone 2, zone 3]"
  type        = "list"
}


##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_name {
  description = "name for the iks cluster"
  default     = "multizone-iks-on-vpc"
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
  description = "enable ALBs"
  default     = true
}

variable only_private_albs {
  description = "enable only private albs"
  default     = false
}

##############################################################################