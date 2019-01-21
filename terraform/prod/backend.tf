terraform {
  backend "gcs" {
    bucket = "terraform-reddit-storage-bucket"
    prefix = "reddit/prod"
  }
}
