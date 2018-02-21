#!/bin/sh

chown root.docker /var/run/docker.sock
/usr/sbin/sshd -D
