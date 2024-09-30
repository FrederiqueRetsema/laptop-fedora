function firewall_settings_chromecast() {
	firewall-cmd --zone=home --change-interface=wlp2s0
	firewall-cmd --permanent --new-service=chromecast
	firewall-cmd --permanent --service=chromecast --set-description=Chromecast
	firewall-cmd --permanent --service=chromecast --set-short=chromecast
	firewall-cmd --permanent --service=chromecast --add-port=32768-61000/udp
	firewall-cmd --permanent --service=chromecast --add-port=8008-8009/tcp
	firewall-cmd --permanent --service=chromecast --add-source-port=32768-61000/udp

	firewall-cmd --permanent --new-service=chromecast-ssdp
	firewall-cmd --permanent --service=chromecast-ssdp --set-description="Chromecast SSDP"
	firewall-cmd --permanent --service=chromecast-ssdp --set-short=chromecast-ssdp
	firewall-cmd --permanent --service=chromecast-ssdp --add-port=1900/udp
	firewall-cmd --permanent --service=chromecast-ssdp --set-destination=ipv4:239.255.255.250/32

	firewall-cmd --permanent --zone=home --add-service=chromecast
	firewall-cmd --zone=home --add-service=chromecast

	firewall-cmd --permanent --zone=home --add-service=chromecast-ssdp
	firewall-cmd --zone=home --add-service=chromecast-ssdp

        firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -m udp -p udp -m pkttype --pkt-type multicast -j ACCEPT
        firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -m udp -p udp -m pkttype --pkt-type multicast -j ACCEPT

	firewall-cmd --set-default-zone=home
	firewall-cmd --reload
}

if test -e /dev/fedora*
then
  echo "-> lvextend -l +100%FREE /dev/fedora*/root"
  lvextend -l +100%FREE /dev/fedora*/root
  echo "-> xfs_growfs /dev/fedora*/root"
  xfs_growfs /dev/fedora*/root
fi

echo "fastmirror=1" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf

echo "-> yum update -y"
yum update -y

echo "-> dnf groupinstall \"GNOME\" -y"
dnf groupinstall "GNOME" -y
echo "-> dnf install dbus-x11 terminator libreoffice libreoffice-langpack-nl snapd timeshift gnome-tweaks git gh awscli2 fedora-workstation-repositories cups quentier -y"
dnf install dbus-x11 terminator libreoffice libreoffice-langpack-nl snapd timeshift gnome-tweaks git gh awscli2 fedora-workstation-repositories cups quentier -y
echo "-> dnf group install --with-optional virtualization -y"
dnf group install --with-optional virtualization -y
echo "-> dnf config-manager --set-enabled google-chrome"
dnf config-manager --set-enabled google-chrome 
echo "-> dnf install google-chrome-stable -y"
dnf install google-chrome-stable -y

# VSCode via yum
VSCODE_REPO_FILE=/etc/yum.repos.d/vscode.repo
echo "[VScode]" > $VSCODE_REPO_FILE
echo "name=vscode" >> $VSCODE_REPO_FILE
echo "baseurl=https://packages.microsoft.com/yumrepos/vscode" >> $VSCODE_REPO_FILE
echo "enabled=1" >> $VSCODE_REPO_FILE
echo "gpgcheck=1" >> $VSCODE_REPO_FILE
echo "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> $VSCODE_REPO_FILE
dnf check-update
dnf install code -y

# MS-Teams via yum not possible, packages directory is missing

# echo "-> ln -s /var/lib/snapd/snap /snap"
# ln -s /var/lib/snapd/snap /snap
# echo "-> sleep 20"
# sleep 20
# echo "-> snap install notepad-plus-plus"
# snap install notepad-plus-plus
# echo "-> snap install code --classic"
# snap install code --classic
# snap install teams-for-linux

echo "-> /etc/hosts"
echo "192.168.68.70 nas" >> /etc/hosts
echo "192.168.68.66 gebruiker-pc" >> /etc/hosts

echo "-> systemctl enable --now cups"
systemctl enable --now cups

echo "-> systemctl enable --now libvirtd"
systemctl enable --now libvirtd
echo "-> mkdir /clone"
mkdir /clone
echo "-> chmod a+rwx /clone"
chmod a+rwx /clone

echo "-> Slack"
flatpak install flathub com.slack.Slack -y

echo "firewall_settings_chromecast"
firewall_settings_chromecast
echo "-> yum update -y"
yum update -y
echo "-> systemctl set-default graphical.target"
systemctl set-default graphical.target

echo "-> Permissions for part 2"
chown frederique:frederique /opt

SECOND_PART=/home/frederique/install-laptop-part2.sh
echo ""
echo "==="
echo "Switching to graphical mode. Read ${SECOND_PART} for second part + manual post-install actions"
echo "(as normal user)"
echo "Press enter"
echo "==="
curl https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/install-laptop-part2.sh > $SECOND_PART

read a
echo "-> systemctl isolate graphical.target"
systemctl isolate graphical.target

