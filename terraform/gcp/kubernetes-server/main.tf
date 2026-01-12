#########################################
# Google Cloud Provider Configuration
#########################################

provider "google" {
  credentials = file("/Users/test/Downloads/terraform-sa.json")
  project     = "kubernetes-practice-474317"
  region      = "asia-southeast1"
}

#########################################
# Use Default VPC Network
#########################################

data "google_compute_network" "default" {
  name = "default"
}

#########################################
# Firewall Rule: Allow All Traffic
#########################################

resource "google_compute_firewall" "allow_all_ingress" {
  name    = "allow-all-ingress"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all"]
}

resource "google_compute_firewall" "allow_all_egress" {
  name    = "allow-all-egress"
  network = data.google_compute_network.default.name

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["allow-all"]
}

#########################################
# VM: Kubernetes Master Node
#########################################

resource "google_compute_instance" "kubernetes_master" {
  name         = "kubernetes-master-node-1"
  machine_type = "e2-small"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    access_config {} # enables public IP
  }

  tags = ["http-server", "https-server", "allow-all"]

  metadata = {
    ssh-keys = "alamin:${file("/Users/test/.ssh/id_ed25519.pub")}"
  }
}

#########################################
# Output Public & Private IPs
#########################################

output "master_public_ip" {
  value = google_compute_instance.kubernetes_master.network_interface[0].access_config[0].nat_ip
}

output "master_private_ip" {
  value = google_compute_instance.kubernetes_master.network_interface[0].network_ip
}
