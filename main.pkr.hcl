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
    destination = "/home/vagrant/.vimrc"
    source = "src/vimrc"
  }
  provisioner "file" {
    destination = "/home/vagrant/.inputrc"
    source = "src/inputrc"
  }
  provisioner "file" {
    destination = "/home/vagrant/.screenrc"
    source = "src/screenrc"
  }
  provisioner "shell" {
    inline = ["mkdir install"]
  }
  provisioner "file" {
    destination = "/home/vagrant/install/"
    source = "src/install/"
  }
  provisioner "shell" {
    script = "src/prepare"
    environment_vars = ["BOX_VERSION=${var.box_version}"]
  }
}
