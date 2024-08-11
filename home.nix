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

  colorscheme = import ./colorscheme.nix;

  # Packages to build, as they are not on NixPkgs
  customPackages = {
    capa = pkgs.callPackage ./capa/capa.nix {};
    jadx = pkgs.callPackage ./jadx/jadx.nix {};
    de4dot = pkgs.callPackage ./de4dot/de4dot.nix {};
    redress = pkgs.callPackage ./redress/redress.nix {};
    webcrack = pkgs.callPackage ./webcrack/webcrack.nix {};
    speakeasy = pkgs.callPackage ./speakeasy/speakeasy.nix {};
    detect-it-easy = pkgs.callPackage ./detect-it-easy/detect-it-easy.nix {};
    binary-refinery = pkgs.callPackage ./binary-refinery/binary-refinery.nix {};
    donut-decryptor = pkgs.callPackage ./donut-decryptor/donut-decryptor.nix {};
  };

  customLibraries = {
    # TODO
  };

  # Work-specific
  fileExists = path: if builtins.pathExists path then import path { inherit pkgs lib; } else {};
  workConfig = fileExists ./work/work.nix;
in
{
  imports = [
    nixvim.homeManagerModules.nixvim

    # Window Manager
    (import ./i3/i3.nix { inherit pkgs config lib homeDirectory shell; })

    # Terminal Setup 
    (import ./kitty/kitty.nix { inherit pkgs colorscheme; })
    (import ./yazi/yazi.nix { inherit pkgs colorscheme workConfig; })
    (import ./zsh/zsh.nix { inherit pkgs customPackages; })
    (import ./neovim/neovim.nix { inherit pkgs homeDirectory; })
    ./git/git.nix
    ./zoxide/zoxide.nix
    ./zathura/zathura.nix
    ./rofi/rofi.nix

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

  packages = (with pkgs // customPackages // customLibraries; [

    # VM tools
    open-vm-tools

    # Backup File Manager
    nautilus

    # Nix-specific tools
    nurl
    nix-init
    node2nix
    nuget-to-nix

    i3
    i3status-rust
    
    # Needed by i3status-rust
    xorg.setxkbmap

    kitty

    git
    zsh-fast-syntax-highlighting

    oh-my-zsh
    thefuck
    tealdeer

    _7zz
    (hiPrio bat)
    ouch
    htop
    glances

    neofetch
    glow

    # Web
    firefox
    
    # Social
    discord

    # Utilities
    xclip
    xsel
    xdragon
    jless

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
    mediainfo
    unar
    poppler

    shared-mime-info

    lazygit
    flatpak # TODO: Make declarative

    ## Malware Analysis
      
    # Binary Analysis
    detect-it-easy
    binary-refinery
    capa
    flare-floss
    imhex
    yara
    upx

    # Family-Specific
    donut-decryptor

    # Shellcode
    speakeasy

    # JavaScript
    webcrack

    # Java
    jadx

    # .NET
    avalonia-ilspy
    ilspycmd
    de4dot

    # Go
    goresym
    redress

    # Android
    apktool

    # TODO
    # rustbinsign (+rustup) - This should be possible w/ poetry?
    # IDR

    # Custom Python environment
    (python311.withPackages (ps: [
      # Custom Libraries - TODO
    ] ++ (with ps; [
      requests
      flask
      netifaces
      mitmproxy
      construct
      unicorn
      capstone
      dnfile
      # qilling
      # mkyara (?)
      # pycdc
      # view8
      # bindiff (?)
      # innoump
    ])))

    # Containers
    dive
    distrobox
    podman-tui
    podman-compose

    # Fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ]) ++ (workConfig.home.packages or []);

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      FONTCONFIG_PATH = "$HOME/.nix-profile/share/fonts/truetype";
      PATH = "$PATH:$HOME/.local/bin";
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

    file.".local/bin/DRAG_TO_VM" = {
      text = ''
        #!${pkgs.zsh}/bin/zsh
        dragon --target | while read dst
        do
          cp "''${dst//file:\/\//}" .
        done
      '';
      executable = true;
    };

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
