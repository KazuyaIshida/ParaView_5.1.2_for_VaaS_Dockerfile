# This Dockerfile creates the Docker image of ParaView (v5.1.2) with OSMesa using llvmpipe.

# FROM ishidakazuya/paraview_5.1.2_mesa-llvm
FROM ishidakazuya/paraview_5.1.2_mesa-llvm:latest

# MAINTAINER is ishidakauya
MAINTAINER ishidakazuya

# Install ssh, sshd and supervisord
RUN yum -y update \
&& yum -y install openssh-server openssh-clients bind-utils epel-release \
&& yum -y install supervisor \
&& yum clean all \
&& sed -i -e s/\#Port\ 22/Port\ 22/ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_dsa_key@\#HostKey\ /etc/ssh/ssh_host_dsa_key@ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_ecdsa_key@\#HostKey\ /etc/ssh/ssh_host_ecdsa_key@ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_ed25519_key@\#HostKey\ /etc/ssh/ssh_host_ed25519_key@ /etc/ssh/sshd_config \
&& sed -i -e s/\#PermitRootLogin\ yes/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
&& sed -i -e s/\#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config \
&& sed -i -e s/\#PermitEmptyPasswords\ no/PermitEmptyPasswords\ yes/ /etc/ssh/sshd_config \
&& ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key \
&& mkdir /root/.ssh \
&& echo "StrictHostKeyChecking=no" > /root/.ssh/config \
&& chmod 600 /root/.ssh/config \
&& chmod 700 /root/.ssh \
&& passwd -d root \
&& echo "[supervisord]" > /etc/supervisord.conf \
&& echo "nodaemon=true" >> /etc/supervisord.conf \
&& echo "[program:sshd]" >> /etc/supervisord.conf \
&& echo "command=/sbin/sshd -D" >> /etc/supervisord.conf \
&& echo "autostart=true" >> /etc/supervisord.conf \
&& echo "autorestart=false" >> /etc/supervisord.conf

# EXPOSE Port 22
EXPOSE 22

# ENTRYPOINT is /usr/bin/supervisord
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf

