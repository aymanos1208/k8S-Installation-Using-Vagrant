# Local Kubernetes Cluster

This project sets up a local Kubernetes cluster using Vagrant and VirtualBox. It creates a master node and a worker node, both configured to run Kubernetes.

## File Descriptions

- `Vagrantfile`: Configures the virtual machines with network settings and provisioning scripts.
- `install_common.sh`: Installs necessary packages, configures the hosts file, disables swap, configures sysctl, and installs Docker.
- `configure-master-node.sh`: Initializes the Kubernetes master node, configures kubectl, installs the Calico network plugin, and creates the join command for worker nodes.
- `configure-worker-nodes.sh`: Executes the join command to add worker nodes to the Kubernetes cluster.
- `join_command.sh`: Contains the generated command to join worker nodes to the master cluster.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Launching the Machines

1. Clone this repository to your local machine:
    ```sh
    git clone <REPOSITORY_URL>
    cd <REPOSITORY_NAME>
    ```

2. Start the Vagrant machines:
    ```sh
    vagrant up
    ```

3. To access the master machine:
    ```sh
    vagrant ssh master
    ```

4. To access the worker machine:
    ```sh
    vagrant ssh node-01
    ```

## Notes

- Ensure that the IP addresses configured in the `Vagrantfile` do not conflict with other IP addresses on your local network.
- You can modify the provisioning scripts to tailor the configurations to your specific needs.