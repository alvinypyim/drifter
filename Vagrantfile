Vagrant.configure("2") do |config|
  config.vm.define "source", autostart: false do |source|
    source.vm.box = "{{.SourceBox}}"
    source.vm.provision :docker 
    source.vm.disk :disk, size: '100GB', primary: true
    source.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--uart1", "off" ]
    end
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
