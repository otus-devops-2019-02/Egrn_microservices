terraform {
  required_version = ">=0.11,<0.12"
}

provider "google" {
  version	= "2.0.0"
  project	= "${var.project}"
  region	= "${var.region}"
}

resource "google_compute_firewall" "firewall_prometheus-default" {
  name        = "allow-9090-for-elect"
  network     = "default"
  target_tags = ["reddit-mon"]
  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }
  source_ranges = "${var.ssh_source_ranges}"
}
