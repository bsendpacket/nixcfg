# Notes
- The installation assumes that you have access to curl and git from your distro's default package manager. These can be removed after installation, as they will be installed via nix. 
- The installation assumes that you do _not_ have i3 already installed. If you have i3 installed, it must be removed prior to installation to prevent conflicts.
- The installation assumes that you have your `/home` directory on the same partition as your `/root` directory. If this is not the case, please use `sudo cp` instead of `sudo ln` for #11.

# Installation
```
1. curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
2. Restart shell
3. nix-channel --add https://nixos.org/channels/nixpkgs-24.05 nixpkgs-stable
4. nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
5. nix-channel --update
6. nix-shell '<home-manager>' -A install
7. nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
8. nix-env -iA nixgl.auto.nixGLDefault
9. rm ~/.config/home-manager -r && git clone https://github.com/bsendpacket/nixcfg ~/.config/home-manager
10. home-manager switch
11. sudo ln ~/.local/share/applications/i3.desktop /usr/share/xsessions/
12. sudo reboot
```
