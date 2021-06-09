variable "box_version" {
  type = string
}

source "vagrant" "example" {
  communicator = "ssh"
  source_path = "hashicorp/bionic64"
  provider = "virtualbox"
  add_force = true
}

build {
  sources = ["source.vagrant.example"]
  provisioner "file" {
    destination = "/home/vagrant"
    sources = [
      "src/.vimrc",
      "src/.inputrc",
      "src/.screenrc",
      "install"
    ]
  }
  provisioner "shell" {
    script = "src/prepare"
    environment_vars = ["BOX_VERSION=${var.box_version}"]
  }
}
