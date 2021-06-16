variable "box_version" {
  type = string
}

source "vagrant" "example" {
  communicator = "ssh"
  source_path = "ubuntu/focal64"
  box_version = "v20210609.0.0"
  provider = "virtualbox"
  add_force = true
  template = "Vagrantfile"
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
  provisioner "file" {
    destination = "/home/vagrant/.gitignore"
    source = "src/gitignore"
  }
  provisioner "file" {
    destination = "/home/vagrant/.gitignore"
    source = "src/gitignore"
  }
  provisioner "file" {
    destination = "/tmp/smb-section.conf"
    source = "src/smb-section.conf"
  }
  provisioner "shell" {
    script = "src/prepare"
    environment_vars = ["BOX_VERSION=${var.box_version}"]
  }
}
