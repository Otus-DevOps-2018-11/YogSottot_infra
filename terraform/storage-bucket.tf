provider "google" {
  version = "1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"

  # Имена поменяйте на другие
  name = ["yogsottot-terraform-reddit-storage-bucket"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
