#!/bin/sh

chown root.docker /var/run/docker.sock
ssh-keygen -A

/usr/sbin/sshd -D
