echo "-> Git"
cd /clone
gh auth login
git clone https://github.com/FrederiqueRetsema/Xforce-unpublished.git
git clone https://github.com/FrederiqueRetsema/aws-bitwarden-pvt.git
git clone https://github.com/FrederiqueRetsema/laptop-fedora.git

echo "-> Login on AWS"
mkdir ~/.aws
cd ~/.aws
curl -O https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/config
aws sso login --profile fra-dev
aws cp s3://frpublic2/persoonlijk/config ~/.aws/config

echo "-> Download wallpapers to /usr/wallpapers"
mkdir -p /usr/wallpapers
chmod a+rw /usr/wallpapers
aws s3 cp s3://frpublic2/persoonlijk/wallpapers.zip /usr/wallpapers/wallpapers.zip --profile fra-frlink
cd /usr/wallpapers
unzip wallpapers.zip
cp /clone/laptop-fedora/change-wallpaper.sh .
chmod a+x change-wallpaper.sh
echo "/usr/wallpapers/change-wallpaper.sh&" | tee -a ~frederique/.bash_profile

echo 'Manual steps:'
echo '- WiFi settings > Gear icon > IPv4 > DNS 8.8.8.8 8.8.4.4 1.1.1.1'
echo '- Tweaks > Mouse and Touchpad > Area'
echo '- Tweaks > Windows > Titlebar buttons (enable maximize, minimize)'
echo '- Install bitwarden'
echo '- Install ublock origin'
echo '- Check chromecast'
