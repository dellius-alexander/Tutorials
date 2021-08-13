#!/usr/bin/env bash
###########################################################
rsync -avz -n -e 'ssh -p port_number' \
user_name@some.example.com:/to/some/directory or file/on/the/target/machine/ \
/to/some/existing/directory/on/host/machine/
