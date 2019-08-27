Vagrant.configure(2) do |config|
  config.vm.box = "generic/centos7"
  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.memory = "4096"
	 vb.cpus = "2"
  end
  config.vm.box_check_update = false
  config.vm.hostname = "testtask"  
###  config.vm.network "public_network"
  config.vm.network "private_network", ip: "192.168.88.200",
  virtualbox__hostonly: true
  config.vm.define "testtask"
  config.vm.synced_folder "src/", "/home/vagrant/deploy"
  config.vm.provision :"shell", path: "installpuppet.sh"
  config.vm.provision "puppet" do |puppet|
	puppet.manifests_path = "manifests"
	puppet.manifest_file = "main.pp"
  end
end