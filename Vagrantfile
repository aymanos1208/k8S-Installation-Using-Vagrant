# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = "bento/ubuntu-24.04"
PUBLIC_MASTER_IP = "192.168.1.100"
PUBLIC_NODE_01_IP = "192.168.1.101"

PRIVATE_MASTER_IP = "192.168.56.30"
PRIVATE_NODE_01_IP = "192.168.56.31"

Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME

  boxes = [
    { :name => "master",  :ippublic => PUBLIC_MASTER_IP, :ipprivate => PRIVATE_MASTER_IP, :cpus => 2, :memory => 4096, :disksize => '80GB' },
    { :name => "node-01", :ippublic => PUBLIC_NODE_01_IP, :ipprivate => PRIVATE_NODE_01_IP, :cpus => 1, :memory => 4096, :disksize => '80GB' },
  ]

  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.hostname = opts[:name]
      box.vm.network :private_network, ip: opts[:ipprivate]
      box.vm.network :public_network, ip: opts[:ippublic], bridge: "en0"

      # Port forwarding for access to the Kubernetes API from outside
      if opts[:name] == "master"
        box.vm.network "forwarded_port", guest: 6443, host: 6443  # API Kubernetes
      end
      box.vm.provider "virtualbox" do |vb|
        vb.name = opts[:name]
        vb.cpus = opts[:cpus]
        vb.memory = opts[:memory]
      end
      box.vm.provision "shell", path:"./install_common.sh"
      if box.vm.hostname == "master" then 
        box.vm.provision "shell", path:"./configure-master-node.sh"
        end
      if box.vm.hostname == "node-01" then ##TODO: create some regex to match worker hostnames
        box.vm.provision "shell", path:"./configure-worker-nodes.sh"
      end

    end
  end
end


