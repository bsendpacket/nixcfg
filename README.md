# Notes
- The installation assumes that you have access to curl and git from your distro's default package manager. These can be removed after installation, as they will be installed via nix. 
- The installation assumes that you do _not_ have i3 already installed. If you have i3 installed, it must be removed prior to installation to prevent conflicts.
- The installation assumes that you have your `/home` directory on the same partition as your `/root` directory. If this is not the case, please use `sudo cp` instead of `sudo ln` for #11.

# Installation
```
1. curl -sSf -L https://install.lix.systems/lix | sh -s -- install
2. Restart shell
3. git clone https://github.com/bsendpacket/nixcfg ~/.config/home-manager && cd ~/.config/home-manager
4. git update-index --assume-unchanged binary-ninja/binary-ninja-url.nix
5. git update-index --assume-unchanged git/git.nix
5. Add information to binary-ninja.nix and git.nix
6. nix-shell
7. home-manager switch
8. exit
9. sudo ln ~/.local/share/applications/i3.desktop /usr/share/xsessions/
10. sudo reboot
```

# FAQ
- My i3 no longer shows up in my list of window managers!

If i3 was updated, the hardlink may break, and you will have to recreate the link. Unfortunately, not all display managers support the use of a softlink- and thus, this is nessasary.
To fix this, enter a TTY (Ctrl+Alt+F3, or whichever combination enters a TTY for your distro of choice) and enter the following commands:
```
sudo rm /usr/share/xsessions/i3.desktop
sudo ln ~/.local/share/applications/i3.desktop /usr/share/xsessions/
```
You can then return to the login screen for most distros with Ctrl+Alt+F7.
