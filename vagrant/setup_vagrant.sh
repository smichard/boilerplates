#!/bin/bash
echo "Provisioning virtual machine..."
apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common git nano unzip resolvconf gnupg snapd zsh hugo
# Installing Docker
echo "Install Docker"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker vagrant
# Installing gcloud
echo "Install gcloud sdk"
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
apt update
apt install -y google-cloud-cli
# Installing gcloud
echo "Install kubectl"
snap install kubectl --classic
# configure resolv.conf file
echo "configure resolv.conf file"
systemctl enable resolvconf.service
systemctl start resolvconf.service
systemctl status resolvconf.service
echo 'nameserver 8.8.8.8' >> /etc/resolvconf/resolv.conf.d/head
echo 'nameserver 8.8.4.4' >> /etc/resolvconf/resolv.conf.d/head
resolvconf --enable-updates
resolvconf -u
# install oh my zsh
echo "install oh my zsh"
runuser -l vagrant -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
chsh -s $(which zsh) vagrant
# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install