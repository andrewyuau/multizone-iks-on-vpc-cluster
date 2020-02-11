##############################################################################
# Create IKS on VPC Cluster
##############################################################################

resource ibm_container_vpc_cluster cluster {

  name               = "${var.cluster_name}"
  vpc_id             = "${data.ibm_is_vpc.vpc.id}"
  flavor             = "${var.machine_type}"
  worker_count       = "${var.worker_count}"
  resource_group_id  = "${data.ibm_resource_group.resource_group.id}"

  zones = [
    {
      subnet_id = "${var.subnet_ids[0]}"
      name      = "${var.ibm_region}-1"
    },
    {
      subnet_id = "${var.subnet_ids[1]}"
      name      = "${var.ibm_region}-2"
    },
    {
      subnet_id = "${var.subnet_ids[2]}"
      name      = "${var.ibm_region}-3"
    }
  ]

  disable_public_service_endpoint = "${var.disable_pse}"

}

##############################################################################


##############################################################################
# Enable Private ALBs, disable public
##############################################################################

resource ibm_container_vpc_alb alb {
  count  = "${var.enable_albs ? 6 : 0}" 
  alb_id = "${lookup(ibm_container_vpc_cluster.cluster.albs[count.index], "id")}"
  enable = "${lookup(ibm_container_vpc_cluster.cluster.albs[count.index], "alb_type") == "public" && var.only_private_albs == true ? false : true}"  
}

##############################################################################