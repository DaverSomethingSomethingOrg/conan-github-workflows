#!/bin/bash

######################################################################
# postCreate.sh
#
# Copyright © 2025 David L. Armstrong
#
# This script installs Docker-CE and GitHub gh client and the ACT
# extension for running and testing GitHub Actions workflows locally
#

. /etc/os-release

case "${ID}" in
    ubuntu | debian)
        # Official `python` image is Debian based.
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get install --no-install-recommends -y \
# TODO            docker-ce \
            gh
        ;;
    almalinux)
        # For RH* support we use AlmaLinux

        sudo dnf install -y 'dnf-command(config-manager)'

        # Configure Docker CE repo
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        
        # Configure the GitHub repo for the gh client
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
 
        # VS Code requires git so we do that in Dockerfile before we get here
        sudo yum install --enablerepo crb -y \
            docker-ce \
            gh
        ;;
    # Otherwise assume the container image comes fully loaded I guess
esac

sudo chgrp docker /var/run/docker.sock
sudo usermod -a -G docker luser
newgrp docker

# Common stuff
gh extension install nektos/gh-act
