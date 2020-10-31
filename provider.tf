variable "ibm_username" {
  description = "user name."
}
variable "ibm_api_key" {
  description = "API key."
}

provider "ibm" {
  softlayer_username = "${var.ibm_username}"
  softlayer_api_key = "${var.ibm_api_key}"
}
