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
5. Add Binary Ninja information to binary-ninja/binary-ninja-url.nix
6. nix-shell
7. home-manager switch
8. exit
9. sudo ln ~/.local/share/applications/i3.desktop /usr/share/xsessions/
10. sudo reboot
```
