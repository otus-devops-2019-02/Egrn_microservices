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
  tags         = ["${var.name_app}","docker-app","reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image_app}"
      type  = "pd-standard"
      size	= "${var.disk_size}"
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
