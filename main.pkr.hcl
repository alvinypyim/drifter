source "vagrant" "example" {
  communicator = "ssh"
  source_path = "hashicorp/precise64"
  provider = "virtualbox"
  add_force = true
}

build {
  sources = ["source.vagrant.example"]
  provisioner "shell" {
    script = "src/prepare"
  }
}
