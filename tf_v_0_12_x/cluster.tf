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
    for_each = "${var.subnet_ids}"
    content {
      subnet_id = "${zones.value}"
      name      = "${var.ibm_region}-${index(var.subnet_ids, zones.value) + 1}"
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
  enable = "${element(ibm_container_vpc_cluster.cluster.albs.*.id.alb_type, count.index) == "public" && var.only_private_albs == true ? false : true}"
}

##############################################################################