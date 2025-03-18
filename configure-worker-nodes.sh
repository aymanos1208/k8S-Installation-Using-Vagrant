#!/bin/bash -e

get_join_command ()
{
echo "[6] Executing join command for worker node..."
sudo /vagrant/join_command.sh
}

get_join_command