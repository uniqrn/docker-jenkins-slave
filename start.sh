#!/bin/sh

chown root.docker /var/run/docker.sock
echo 'PATH=/home/jenkins/google-cloud-sdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' > /home/jenkins/.ssh/environment
chown jenkins.jenkins /home/jenkins/.ssh/environment

ssh-keygen -A

/usr/sbin/sshd -D
