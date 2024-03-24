# laptop-fedora
Install repo for fedora laptop

## Set up new Fedora laptop
1) Start the PXE server
2) Start the laptop (F12 into PXE)
   - Mind to encrypt the disk
   - After install, use `sudo -i` to become root
3) Use (as root) the following command to install git, authenticate to git and start the installation  
   `curl https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/install-laptop-part1.sh | bash`
4) Follow the instructions
