source "vagrant" "example" {
  communicator = "ssh"
  source_path = "hashicorp/bionic64"
  provider = "virtualbox"
  add_force = true
}

build {
  sources = ["source.vagrant.example"]
  provisioner "shell" {
    script = "src/prepare"
  }
}
