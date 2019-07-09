terraform {
  required_version = ">=0.11,<0.12"
}


provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}


resource "google_compute_instance" "insts" {
  count        = "${var.app_count}"
  name         = "${var.name_app}-${count.index + 1}"
  machine_type = "${var.machine}"
  zone         = "${var.zone}"
  tags         = ["${var.name_app}","reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image_app}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}

    # nat_ip = "${google_compute_address.app_ip.address}"
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}


resource "google_compute_firewall" "firewall_puma" {
  name          = "allow-9292-for-all"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-app", "reddit-app"]

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
}
