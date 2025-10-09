provider "google" {
  credentials = file("/Users/test/Downloads/terraform-sa.json")
  project     = "kubernetes-practice-474317"
  region      = "asia-southeast1"
}

# Use the default VPC network (Google Cloud automatically creates this network)
data "google_compute_network" "default" {
  name = "default"
}

# Create Server 1
resource "google_compute_instance" "server_1" {
  name         = "kubernetes-master-node-1"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    
    access_config {}
  }

  tags = ["http-server", "https-server"]

  metadata = {
    ssh-keys = file("/Users/test/.ssh/id_ed25519.pub")
  }
}

# Create Server 2
resource "google_compute_instance" "server_2" {
  name         = "kubernetes-worker-node-2"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    
    access_config {}
  }

  tags = ["http-server", "https-server"]

  metadata = {
    ssh-keys = file("/Users/test/.ssh/id_ed25519.pub")
  }
}

# Create Server 3
resource "google_compute_instance" "server_3" {
  name         = "kubernetes-worker-node-3"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    
    access_config {}
  }

  tags = ["http-server", "https-server"]

  metadata = {
    ssh-keys = file("/Users/test/.ssh/id_ed25519.pub")
  }
}

# Output for IP addresses
output "server_1_ip" {
  value = google_compute_instance.server_1.network_interface[0].access_config[0].nat_ip
}

output "server_2_ip" {
  value = google_compute_instance.server_2.network_interface[0].access_config[0].nat_ip
}

output "server_3_ip" {
  value = google_compute_instance.server_3.network_interface[0].access_config[0].nat_ip
}
