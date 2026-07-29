echo "-> Git"
cd /clone
gh auth login -p https -w
git config --global credential.helper store
git clone https://github.com/FrederiqueRetsema/aws-bitwarden-pvt.git
git clone https://github.com/FrederiqueRetsema/laptop-fedora.git

echo "-> Login on AWS"
mkdir ~/.aws
cd ~/.aws
curl -O https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/config
aws sso login --profile fra-dev
aws s3 cp s3://frpublic2/persoonlijk/config ~/.aws/config --profile fra-dev

