# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest")
    # Do set auto_update to `false`
    # It causes errors during building GuestAdditions
    config.vbguest.auto_update = false
  end
  config.vm.box = "centos/8"
  config.vm.provision "shell", path: "provision.sh"
end
