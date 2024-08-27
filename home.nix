{
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

  # Force protobuf5 over protobuf4
  # The NixPkg for angr uses protobuf4, although it works with protobuf5
  # By forcing protobuf5 here, conflicts of multiple versions existing is prevented
  protobufOverlay = self: super: {
    python312Packages = super.python312Packages.override {
      overrides = pythonSelf: pythonSuper: {
        protobuf = pythonSuper.protobuf5;
      };
    };
  };

  pkgs = import <nixpkgs> {
    overlays = [ protobufOverlay ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Packages to build, as they are not on NixPkgs
  customPackages = {
    jadx = pkgs.callPackage ./jadx/jadx.nix { };
    de4dot = pkgs.callPackage ./de4dot/de4dot.nix { };
    redress = pkgs.callPackage ./redress/redress.nix { };
    webcrack = pkgs.callPackage ./webcrack/webcrack.nix { };
    detect-it-easy = pkgs.callPackage ./detect-it-easy/detect-it-easy.nix { };
    net-reactor-slayer = pkgs.callPackage ./net-reactor-slayer/net-reactor-slayer.nix { };

    # Python Packages
    capa = pkgs.callPackage ./capa/capa.nix { };
    speakeasy = pkgs.callPackage ./speakeasy/speakeasy.nix { };
    binary-refinery = pkgs.callPackage ./binary-refinery/binary-refinery.nix { };
    donut-decryptor = pkgs.callPackage ./donut-decryptor/donut-decryptor.nix { };
    dncil = pkgs.callPackage ./dependencies/dncil.nix { };
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
    (import ./alacritty/alacritty.nix { inherit pkgs colorscheme; })
    (import ./yazi/yazi.nix { inherit pkgs colorscheme workConfig; })
    (import ./zsh/zsh.nix { inherit pkgs customPackages workConfig; })
    (import ./neovim/neovim.nix { inherit pkgs homeDirectory; })
    ./git/git.nix
    ./zoxide/zoxide.nix
    ./zathura/zathura.nix
    ./rofi/rofi.nix
    ./malwoverview/malwoverview.nix

    ./contour/settings.nix
    (import ./contour/contour.nix { inherit lib pkgs colorscheme; })

    # Services
    ./picom/picom.nix
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = (with pkgs // customPackages; [

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
      alacritty
      contour

      git
      zsh-fast-syntax-highlighting

      oh-my-zsh
      thefuck
      tealdeer

      man-pages
      man-pages-posix

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

      rofi
      inxi

      ffmpegthumbnailer
      mediainfo
      unar
      poppler

      shared-mime-info

      lazygit
      poetry
      flatpak # TODO: Make declarative

      rustup

      sqlitebrowser

      ## Malware Analysis

      # Triage
      malwoverview
        
      # Binary Analysis
      detect-it-easy
      flare-floss
      imhex
      capa
      yara
      upx

      # Family-Specific
      donut-decryptor

      # InnoSetup
      innoextract

      # Networking
      wireshark

      # JavaScript
      webcrack

      # Java
      jadx

      # .NET
      avalonia-ilspy
      ilspycmd
      de4dot
      net-reactor-slayer

      # Go
      goresym
      redress

      # Android
      apktool

      # Emulation
      speakeasy

      # TODO
      # rustbinsign (+rustup) - This should be possible w/ poetry?
      # IDR

      # Custom Python environment
      (python312.withPackages (ps: with ps; [
        pip
        setuptools
        wheel

        # Regex
        exrex

        # Networking
        requests
        flask
        netifaces
        mitmproxy

        # Binary Analysis
        binary-refinery
        construct

        # .NET
        dnfile
        dncil

        # Emulation
        unicorn
        capstone

      ]))
      # qilling
      # mkyara (?)
      # pycdc
      # view8
      # bindiff (?)
      # innoump

      # Containers
      dive
      distrobox
      podman
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
