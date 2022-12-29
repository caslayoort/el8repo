To build OpenSSH 9.1p1, we need to clone the repository and use some dependencies (OpenSSL and X11 SSH askpass).

In the OpenSSH repository (https://github.com/openssh/openssh-portable) there is a openssh.spec file in the contrib/redhat folder. This is the file which specifies the way the RPM file will be build. During the build, 3 sources will be used:
- OpenSSL 1.1.1s (https://www.openssl.org/source/openssl-1.1.1s.tar.gz)
- X11 SSH Askpass (https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz)
- Tar.gz file with the OpenSSH-9.1p1 source code
