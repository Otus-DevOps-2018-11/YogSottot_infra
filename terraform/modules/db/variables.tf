variable zone {
  description = "Zone"
  default     = "europe-north1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable count_db {
  description = "Count DB instances"
  default     = "1"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}
