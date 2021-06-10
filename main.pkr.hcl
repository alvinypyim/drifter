variable "box_version" {
  type = string
}

source "vagrant" "example" {
  communicator = "ssh"
  source_path = "hashicorp/bionic64"
  provider = "virtualbox"
  add_force = true
  template = <<-EOT
    Vagrant.configure("2") do |config|
      config.vm.define "source", autostart: false do |source|
      source.vm.box = "{{.SourceBox}}"
      config.ssh.insert_key = {{.InsertKey}}
      end
      config.vm.define "output" do |output|
      output.vm.box = "{{.BoxName}}"
      output.vm.box_url = "file://package.box"
      config.ssh.insert_key = {{.InsertKey}}
      end
      {{ if ne .SyncedFolder "" -}}
          config.vm.synced_folder "{{.SyncedFolder}}", "/vagrant"
      {{- else -}}
          config.vm.synced_folder ".", "/vagrant", disabled: true
      {{- end}}
    end
  EOT
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
