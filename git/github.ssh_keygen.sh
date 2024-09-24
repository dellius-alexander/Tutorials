#!/usr/bin/env bash
###########################################################
config_file=$( [[ -f $2  ]]  )
echo $config_file
create_ssh(){
    $email=$1
    ssh-keygen -a 128  -t ed25519 -f ./.ssh/id_ed25519_jenkins_github -C "$email";

}
