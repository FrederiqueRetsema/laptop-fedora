
if test -e /dev/fedora*
then
  echo "-> lvextend -l +100%FREE /dev/fedora*/root"
  lvextend -l +100%FREE /dev/fedora*/root
  echo "-> xfs_growfs /dev/fedora*/root"
  xfs_growfs /dev/fedora*/root
fi

echo "fastmirror=1" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf

echo "-> dnf update -y"
dnf update -y

echo "-> dnf groupinstall \"GNOME\" -y"
dnf groupinstall "GNOME" -y
echo "-> dnf install dbus-x11 terminator snapd timeshift gnome-tweaks git gh awscli2 fedora-workstation-repositories cups quentier -y"
dnf install dbus-x11 terminator snapd timeshift gnome-tweaks git gh awscli2 fedora-workstation-repositories cups quentier -y
echo "-> dnf group install --with-optional virtualization -y"
dnf group install --with-optional virtualization -y
echo "-> dnf config-manager --set-enabled google-chrome"
dnf config-manager --set-enabled google-chrome 
echo "-> dnf install google-chrome-stable -y"
dnf install google-chrome-stable -y

echo "-> /etc/hosts"
echo "192.168.68.70 nas" >> /etc/hosts

echo "-> NAS"
mkdir -p /mnt/nas

SCRIPTFILE="/root/backup.sh"
echo '#!/bin/bash' > ${SCRIPTFILE}
echo 'mount -t cifs -o credentials=/etc/smbcredentials/nas.cred,uid=1000,gid=1000,file_mode=0777,dir_mode=0777 //nas/Backup/eigen-linux-nas /mnt/nas' >> ${SCRIPTFILE}
echo 'MONTH="$(date +%2m)"' >> ${SCRIPTFILE}
echo 'BACKUP_DIR="/mnt/nas/${MONTH}/"' >> ${SCRIPTFILE}
echo 'mkdir -p "${BACKUP_DIR}"' >> ${SCRIPTFILE}
echo 'cp -v -r /clone "${BACKUP_DIR}/clone"' >> ${SCRIPTFILE}
echo 'cp -v -r /mnt/disks "${BACKUP_DIR}/disks"' >> ${SCRIPTFILE}
echo 'cp -v -r ~frederique/.kiro "${BACKUP_DIR}/.kiro"' >> ${SCRIPTFILE}
echo 'cp -v -r ~frederique/Downloads "${BACKUP_DIR}/downloads"' >> ${SCRIPTFILE}

chmod 700 ${SCRIPTFILE}

SCRIPTFILE="/root/mount.sh"
echo '#!/bin/bash' > ${SCRIPTFILE}
echo 'mount -t cifs -o credentials=/etc/smbcredentials/nas.cred,uid=1000,gid=1000,file_mode=0777,dir_mode=0777 //nas/Backup/eigen-linux-pc /mnt/nas' >> ${SCRIPTFILE}
chmod 700 ${SCRIPTFILE}

echo "-> systemctl enable --now cups"
systemctl enable --now cups

echo "-> sshd via passwords"
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl daemon-reload
systemctl restart sshd

echo "-> dnf update -y"
dnf update -y

echo "Install disks (assuming that you created a backup!): press enter to install disks"
read a
# OS is on /dev/sdc
wipefs --all /dev/sda
wipefs --all /dev/sdb
pvcreate /dev/sda
pvcreate /dev/sdb
vgcreate disks /dev/sda /dev/sdb
lvcreate --type raid1 disks --size 1.5t --name data
mkfs.ext4 /dev/disks/data
echo "/dev/disks/data /mnt/data ext4 defaults 0 0" >> /etc/fstab
mount -a

echo "-> Install NFS"
adduser -c 'nfs pseudo user' -b /nonexisting -M -r -s /usr/bin/nologin nfs
chown nfs:nfs /mnt/data
chmod a+w /mnt/data
firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload
echo "/mnt/data *(rw,sync)" > /etc/exports.d/data.exports
systemctl enable nfs-server --now
exportfs -r

echo "-> Don't suspend automatically"
mkdir -p /etc/systemd/sleep.conf.d/
echo -e "[Sleep]\nAllowSuspend=no\nAllowHibernation=no\nAllowSuspendThenHibernate=no\nAllowHybridSleep=no" | sudo tee /etc/systemd/sleep.conf.d/override.conf
systemctl daemon-reload

echo "-> Permissions for part 2"
mkdir -p /clone
chown frederique:frederique /opt
chown frederique:frederique /clone

SECOND_PART=install-gebruiker-pc-part2.sh
cp "./${SECOND_PART}" "/home/frederique/${SECOND_PART}"

