#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# The location of the spec file in the git repo
OpenSSHSpecFileLocation="contrib/redhat/openssh.spec"

# Get OpenSSH Repo
git clone https://anongit.mindrot.org/openssh.git openssh && cd openssh
git fetch -a
git checkout origin/V_9_1
touch ChangeLog # Needs to be there for the build.
sed -i 's/BuildRequires: openssl-devel < 1.1//g' $OpenSSHSpecFileLocation
autoreconf # rpmbuild will run ./configure himself but it won't run this command.
cd ..

# Declare versions
OpenSSLVersion="1.1.1s"
OpenSSHVersion=$(grep -i '^%global ver' "openssh/$OpenSSHSpecFileLocation" | awk '{print $3}')

# Adding OpenSSH source code to SOURCES folder
mkdir -p ./SOURCES
mv openssh "openssh-${OpenSSHVersion}" && \
tar -czvf "./SOURCES/openssh-${OpenSSHVersion}.tar.gz" "openssh-${OpenSSHVersion}"

# Fetch build dependencies
wget -O "./SOURCES/openssl-${OpenSSLVersion}.tar.gz" "https://www.openssl.org/source/openssl-${OpenSSLVersion}.tar.gz"
wget -O ./SOURCES/x11-ssh-askpass-1.2.4.1.tar.gz https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz

# Creating the RPM files
rpmbuild -ba "openssh-${OpenSSHVersion}/${OpenSSHSpecFileLocation}" --target $(uname -m) --define "_topdir $PWD" \
	--define "opensslver ${OpenSSLVersion}" \
	--define "opensshver ${OpenSSHVersion}" \
	--define "opensshpkgrel 2"
