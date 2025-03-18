# -*- mode: ruby -*-
# vi: set ft=ruby :

IMAGE_NAME = "bento/ubuntu-24.04"
MASTER_IP = "192.168.56.30"
NODE_01_IP = "192.168.56.31"

Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME

  boxes = [
    { :name => "master",  :ip => MASTER_IP,  :cpus => 2, :memory => 2048 },
    { :name => "node-01", :ip => NODE_01_IP, :cpus => 1, :memory => 2048 },
  ]

  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.hostname = opts[:name]
      box.vm.network :private_network, ip: opts[:ip]
      box.vm.provider "virtualbox" do |vb|
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

# NODE_IP = "192.168.56.3"
# Vagrant.configure("2") do |config|
#   # master server
#   config.vm.define "master" do |master|
#     master.vm.box = IMAGE_NAME
#     master.vm.hostname = "Master"
#     master.vm.network "public_network", ip: MASTER_IP
#     master.vm.provider :virtualbox do |v|
#       v.name = "master"
#       v.memory = 2048
#       v.cpus = 2
#     end
#     config.vm.provision "shell", inline: <<-SHELL
#       sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
#       service ssh restart
#     SHELL
#     master.vm.provision "shell", path: "install_common.sh"
#     master.vm.provision "shell", path:"configure-master-node.sh"
#   end

  # numberSrv=2
  # # workers server
  # (1..numberSrv).each do |i|
  #   config.vm.define "node#{i}" do |node|
  #     node.vm.box = IMAGE_NAME
  #     node.vm.hostname = "node#{i}"
  #     node.vm.network "public_network", ip: "#{NODE_IP}#{i}"
  #     node.vm.provider "virtualbox" do |v|
  #       v.name = "node#{i}"
  #       v.memory = 2048
  #       v.cpus = 1
  #     end
  #     config.vm.provision "shell", inline: <<-SHELL
  #       sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
  #       service ssh restart
  #     SHELL
  #     # node.vm.provision "shell", path: "install_common.sh"
  #     # node.vm.provision "shell", path:"configure-worker-nodes.sh"
  #   end
  # end
# end


