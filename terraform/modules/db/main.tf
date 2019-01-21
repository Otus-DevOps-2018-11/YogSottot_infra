resource "google_compute_instance" "db" {
  count        = "${var.count_db}"
  name         = "reddit-db-${format("%02d", count.index+1)}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config = {}
  }


connection {
      type        = "ssh"
      user        = "appuser"
      agent       = false
      private_key = "${file(var.private_key_path)}"
    }

  provisioner "remote-exec" {
    inline = [
      "sed -i sed -i 's/127\.0\.0\.1/"${self.private_ip}"/g' /etc/mongod.conf",
      "sudo systemctl restart mongod.service"
    ]
  }


}

# Правило firewall
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
