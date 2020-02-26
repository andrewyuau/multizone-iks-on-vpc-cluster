##############################################################################
# Create IKS on VPC Cluster
##############################################################################

resource ibm_container_vpc_cluster cluster {

  name               = "${var.cluster_name}"
  vpc_id             = "${data.ibm_is_vpc.vpc.id}"
  flavor             = "${var.machine_type}"
  worker_count       = "${var.worker_count}"
  resource_group_id  = "${data.ibm_resource_group.resource_group.id}"

  dynamic zones {
    for_each = "${var.cluster_zones}"
    content {
      subnet_id = "${zones.value.subnet_id}"
      name      = "${var.ibm_region}-${zones.value.zone}"
    }
  }

  disable_public_service_endpoint = "${var.disable_pse}"
}

##############################################################################


##############################################################################
# Enable Private ALBs, disable public
##############################################################################

resource ibm_container_vpc_alb alb {
  count  = "6" 
  
  alb_id = "${element(ibm_container_vpc_cluster.cluster.albs.*.id, count.index)}"
  enable = "${
    var.enable_albs && !var.only_private_albs 
    ? true
    : var.only_private_albs && "${element(ibm_container_vpc_cluster.cluster.albs.*.alb_type, count.index)}" != "public" 
      ? true
      : false
  }"
}

##############################################################################


##############################################################################
# Cluster Pool Module
##############################################################################

module worker_pool {
  source            = "./additional_assets/worker_pool"

  worker_pool_name  = "todd"
  ibm_region        = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  cluster_name_id   = "${ibm_container_vpc_cluster.cluster.id}"
  vpc_id            = "${data.ibm_is_vpc.vpc.id}"
  pool_zones        = "${var.cluster_zones}"
  worker_count      = 1

}

##############################################################################


##############################################################################
# ALB Cert Module
##############################################################################
module alb_cert {
  source            = "./additional_assets/alb_cert"
  cms_name          = "jv-iks-dev-cms"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  cluster_id        = "${ibm_container_vpc_cluster.cluster.id}"
}

##############################################################################