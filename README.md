# laptop-fedora
Install repo for fedora laptop

## Set up new Fedora laptop
1) Start the PXE server or insert USB stick
2) Start the laptop (F12 into PXE for PXE)
   - Mind to encrypt the disk
   - After install, use `sudo -i` to become root
3) Use (as root) the following command to start the installation  
   `curl https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/install-laptop-part1.sh | bash`
4) Follow the instructions
5) As user, first download the part 2 part, then execute this:
```
curl -O https://raw.githubusercontent.com/FrederiqueRetsema/laptop-fedora/main/install-laptop-part2.sh
. ./install-laptop-part2.sh 
```

# Reminders
- Evernote = Quentier / Notion (web app)
