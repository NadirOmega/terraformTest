

provider "ibm" {
  ibmcloud_api_key = "qTqXQBVLLncav5JPO2Ck2f4x7vjtBhnkuSJ-pa4lJy5E"
}

data ibm_resource_group group {
  name = "ITGP_DATA"
}

#data ibm_container_cluster k8s {
#  resource_group_id = data.ibm_resource_group.group.id
#  cluster_name_id = "kb-bnpp-itgp-data06-yl-kc-dev"
#}
##############################################################################


##############################################################################
# Cluster Data
##############################################################################

data ibm_container_cluster_config cluster {
  cluster_name_id   = "kb-bnpp-itgp-data06-yl-kc-dev"
  resource_group_id = "${data.ibm_resource_group.group.idvar.ami}"
  admin             = true
}

##############################################################################


##############################################################################
# Kubernetes Provider
##############################################################################

provider kubernetes {
  load_config_file       = false
  host                   = "${data.ibm_container_cluster_config.cluster.host}"
  client_certificate     = "${data.ibm_container_cluster_config.cluster.admin_certificate}"
  client_key             = "${data.ibm_container_cluster_config.cluster.admin_key}"
  cluster_ca_certificate = "${data.ibm_container_cluster_config.cluster.ca_certificate}"
}


##############################################################################
# Kubernetes Provider
##############################################################################

provider "helm" {
  kubernetes {
  config_path = "${data.ibm_container_cluster_config.cluster.config_file_path}"
  load_config_file       = false
    host                   = "${data.ibm_container_cluster_config.cluster.host}"
    client_certificate     = "${data.ibm_container_cluster_config.cluster.admin_certificate}"
    client_key             = "${data.ibm_container_cluster_config.cluster.admin_key}"
    cluster_ca_certificate = "${data.ibm_container_cluster_config.cluster.ca_certificate}"
}
}


 
resource "helm_release" "cassandra" {
  # depends_on = ["data.ibm_container_cluster.k8s"]
   name      = "CassandraTestHelm"
   force_update= true
     wait       = true
  timeout    = 200
   repository = "https://charts.bitnami.com/bitnami"
   chart     = "bitnami/cassandra"
   namespace = "ververica32"
}
