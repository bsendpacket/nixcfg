{
  pkgs,
  config,
  lib,
  ...
}:
let
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    shell = builtins.getEnv "SHELL";

    nixvim = import (builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim

    # Window Manager
    (import ./i3/i3.nix { inherit pkgs config lib homeDirectory shell; })

    # Terminal Setup 
    ./kitty/kitty.nix
    ./zsh/zsh.nix
    ./git/git.nix
    ./zoxide/zoxide.nix
    ./yazi/yazi.nix
    ./zathura/zathura.nix
    ./rofi/rofi.nix
    ./neovim/neovim.nix

    # Services
    ./picom/picom.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = with pkgs; [

      i3
      i3status-rust
      
      # Needed by i3status-rust
      xorg.setxkbmap

      kitty

      git
      zsh-fast-syntax-highlighting

      oh-my-zsh
      thefuck

      _7zz
      ouch
      htop
      glances

      neofetch
      glow
      
      # Social
      discord

      # Utilities
      xclip
      xdragon

      bat
      lsd
      zoxide
      fzf
      fd
      ripgrep
      jq
      yazi
      hexyl
      ueberzugpp

      rofi
      inxi

      ffmpegthumbnailer
      unar
      poppler

      lazygit

      # Custom Python environment
      (python311.withPackages (ps: with ps; [
        requests
        flask
        netifaces
        mitmproxy
        construct
      ]))

      dive
      distrobox
      podman-tui
      podman-compose

      # Fonts
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })

      # Filesystem
    ];

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      FONTCONFIG_PATH = "$HOME/.nix-profile/share/fonts/truetype";
    };

    file.".xsessionrc" = {
      text = ''
        #!/bin/sh
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
        export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
        export FONTCONFIG_PATH="$HOME/.nix-profile/etc/fonts"
      '';
      executable = true;
    };

    file.".local/share/applications/i3.desktop" = {
      text = ''
        [Desktop Entry]
        Name=i3
        Comment=improved dynamic tiling window manager
        Exec=${pkgs.i3}/bin/i3
        Type=Application
      '';
      executable = false;
    };

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
