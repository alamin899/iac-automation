provider "google" {
  credentials = file("/Users/test/Downloads/terraform-sa.json")  # Path to your gcloud JSON key (no need for local gcloud cli)
  project     = "kubernetes-practice-474317"
  region      = "asia-southeast1"
}

# Use the default VPC network (Google Cloud automatically creates this network)
data "google_compute_network" "default" {
  name = "default"  # The name of the default network in Google Cloud
}

resource "google_compute_instance" "default" {
  name         = "kubernetes-master-node-1"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    # Reference the default VPC network directly
    network = data.google_compute_network.default.self_link
    
    access_config {
      # This ensures the instance gets a public IP address (NAT IP)
    }
  }

  tags = ["http-server", "https-server"]

  metadata = {
    ssh-keys = file("/Users/test/.ssh/id_ed25519.pub") # Path to your public SSH key
  }
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
