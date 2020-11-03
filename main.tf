

provider "ibm" {
  ibmcloud_api_key = "${var.ibm_api_key}"
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
  cluster_name_id   = "cluster-tests-apache-kc-didier"
  resource_group_id = "4d16a8e0e25e4ff6b33045ec2a43ddf5"
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

#data "helm_repository" "cassandra_repo" {
 # namespace= "test"
 # name = "incubator"
 # url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
#}
 
resource "helm_release" "cassandra" {
   create_namespace =true
   namespace = "test2"
   #depends_on = ["data.ibm_container_cluster.k8s"]
   name      = "cassandratestwarm2"
  repository = "https://charts.bitnami.com/ibm"
   chart     = "cassandra"
   timeout = 600
   cleanup_on_fail = true   
  set {
    name  = "persistence.enabled"
    value = "false"
  }
}
