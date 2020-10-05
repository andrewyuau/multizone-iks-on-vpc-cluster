##############################################################################
# Create IKS on VPC Cluster
##############################################################################

resource "ibm_resource_instance" "cos_instance" {
  name     = "${var.cos_instance_name}"
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}

resource ibm_container_vpc_cluster cluster {

  name               = "${var.cluster_name}"
  vpc_id             = "${data.ibm_is_vpc.vpc.id}"
  kube_version       = "${var.kube_version}"
  flavor             = "${var.machine_type}"
  worker_count       = "${var.worker_count}"
  entitlement       = "${var.entitlement}"
  cos_instance_crn  = ibm_resource_instance.cos_instance.id
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
