{
  config,
  lib,
  ...
}:
let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  isNixOS = builtins.pathExists "/etc/NIXOS";
  colorscheme = import ./colorscheme.nix;
  nixGLPrefix = if isNixOS then "" else "${channels.nixpkgs-unstable.nixGL.auto.nixGLDefault}/bin/nixGL ";

  channels = (import ./channels.nix).channels;

  binaryNinjaURL = import ./binary-ninja/binary-ninja-url.nix;
  binaryNinjaConfig = import ./binary-ninja/config.nix { inherit channels; };

  # Packages to build, as they are not on NixPkgs
  customPackages = {
    jadx = channels.nixpkgs-unstable.callPackage ./jadx/default.nix { };
    de4dot = channels.nixpkgs-unstable.callPackage ./de4dot/de4dot.nix { };
    redress = channels.nixpkgs-unstable.callPackage ./redress/redress.nix { };
    webcrack = channels.nixpkgs-unstable.callPackage ./webcrack/webcrack.nix { };
    frida-tools = channels.nixpkgs-unstable.callPackage ./dependencies/frida-tools.nix { };
    decompylepp = channels.nixpkgs-unstable.callPackage ./decompylepp/decompylepp.nix { };
    detect-it-easy = channels.nixpkgs-unstable.callPackage ./detect-it-easy/detect-it-easy.nix { };
    net-reactor-slayer = channels.nixpkgs-unstable.callPackage ./net-reactor-slayer/net-reactor-slayer.nix { };

    # Python Packages
    capa = channels.nixpkgs-unstable.callPackage ./capa/capa.nix { };
    speakeasy = channels.nixpkgs-unstable.callPackage ./speakeasy/speakeasy.nix { };
    binary-refinery = channels.nixpkgs-unstable.callPackage ./binary-refinery/binary-refinery.nix { };
    donut-decryptor = channels.nixpkgs-unstable.callPackage ./donut-decryptor/donut-decryptor.nix { };
    dncil = channels.nixpkgs-unstable.callPackage ./dependencies/dncil.nix { };

    binary-ninja = channels.nixpkgs-unstable.callPackage ./binary-ninja/binary-ninja.nix { 
      binaryNinjaUrl = binaryNinjaURL.binaryNinjaUrl;
      binaryNinjaHash = binaryNinjaURL.binaryNinjaHash;
      pythonEnv = binaryNinjaConfig.pythonEnv;
    };
  };

  # Work-specific
  fileExists = path: if builtins.pathExists path then import path { inherit channels lib; } else {};
  workConfig = fileExists ./work/work.nix;

  # Python Environments
  pythonEnvs = import ./python/venvs.nix { inherit channels customPackages; };

in
{
  imports = [
    channels.nixvim.homeManagerModules.nixvim

    # Window Manager
    (import ./i3/i3.nix { inherit channels config lib nixGLPrefix; })

    # Git
    (import (if builtins.pathExists ./work/git/git.nix then ./work/git/git.nix else ./git/git.nix))

    # Terminal Setup 
    (import ./tmux/tmux.nix { inherit channels; })
    # (import ./kitty/kitty.nix { inherit channels colorscheme; })
    # (import ./alacritty/alacritty.nix { inherit channels colorscheme; })
    (import ./yazi/yazi.nix { inherit channels config colorscheme workConfig nixGLPrefix; })
    (import ./zsh/zsh.nix { inherit lib channels customPackages workConfig nixGLPrefix colorscheme; })
    (import ./neovim/neovim.nix { inherit channels homeDirectory; })
    (import ./rofi/rofi.nix { inherit channels config; })
    (import ./contour/settings.nix { inherit channels config lib; })
    (import ./contour/contour.nix { inherit channels lib colorscheme; })
    (import ./zoxide/zoxide.nix { inherit channels; })

    ./zathura/zathura.nix
    ./malwoverview/malwoverview.nix

    # Services
    ./picom/picom.nix

    binaryNinjaConfig.binaryNinjaConfig

    # Program Setup
    (import ./firefox/firefox.nix { inherit channels lib; })
  ];

  programs.home-manager = {
    enable = true;
    path = "${channels.nixpkgs-unstable.home-manager.src}";
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = (with channels.nixpkgs-unstable // customPackages; [
      # VM tools
      open-vm-tools

      # Backup File Manager
      nautilus

      # Touchpad
      libinput-gestures
      wmctrl
      xdotool

      # Display
      brightnessctl

      # Nix-specific tools
      nurl
      nix-init
      node2nix
      nuget-to-nix

      i3
      i3status-rust
      
      # Needed by i3status-rust
      xorg.setxkbmap

      # Find pressed key
      xorg.xev

      # kitty
      # alacritty
      contour

      tmux

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

      obsidian

      lxqt.screengrab

      # RSS
      nom

      # Web
      #firefox
      
      # Social
      discord

      # Utilities
      xclip
      xsel
      xdragon
      jless
      p7zip
      unar

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
      exiftool
      unar
      file
      poppler

      shared-mime-info

      lazygit
      poetry
      flatpak # TODO: Make declarative

      gcc
      zig
      rustup
      rustlings
      typescript
      nodejs_22

      sqlitebrowser

      ## Malware Analysis

      # Triage
      malwoverview
        
      # Binary Analysis
      detect-it-easy
      binary-ninja
      frida-tools
      flare-floss
      imhex
      capa
      upx

      yara-x
      yaralyzer

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

      # Python
      decompylepp

      # Android
      apktool

      # Emulation
      speakeasy

      # TODO
      # rustbinsign (+rustup) - This should be possible w/ poetry?
      # IDR

      # Custom Python environment
      (channels.nixpkgs-unstable.python312.withPackages (ps: with channels.nixpkgs-unstable.python312Packages; [
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
        frida-python
        construct

        # .NET
        dnfile
        dncil

        # Emulation
        unicorn
        capstone

      ] ++ (workConfig.home.pythonPackages or [])))

      # qilling
      # mkyara (?)
      # pycdc
      # view8
      # bindiff (?)
      # innoump

      # Containers
      dive
      distrobox

      # podman is broken on nix at the moment, if not on NixOS
      # podman
      # podman-tui
      # podman-compose

      # Fonts
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })

    ]) ++ (workConfig.home.packages or []) ++ (if !isNixOS then [ channels.nixpkgs-unstable.nixGL.auto.nixGLDefault ] else []);
    
    # Create symlinks to the Python venvs in ~/.virtualenvs
    activation.buildPythonEnvs = lib.mkAfter ''
      echo "Building Python environments..."
      ${lib.concatStringsSep "\n" (map (env:
        ''
        VENV_DIR="${config.home.homeDirectory}/.virtualenvs/${env.name}"

        # Ensure the environment directory exists
        mkdir -p "$VENV_DIR"

        # Remove any existing symlinks
        find "$VENV_DIR" -maxdepth 1 -type l -exec rm -f {} \;

        # Create a symlink to the Python environment
        ln -sf ${env.pythonEnv} "$VENV_DIR"

        # Create a symlink to the Python binary
        mkdir -p "$VENV_DIR/bin"
        ln -sf ${env.pythonEnv}/bin/python "$VENV_DIR/bin/python"
        ''
      ) pythonEnvs.envs)}
    '';

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
        Exec=${channels.nixpkgs-unstable.i3}/bin/i3
        Type=Application
      '';
      executable = false;
    };

    file.".local/bin/DRAG_TO_VM" = {
      text = ''
        #!${channels.nixpkgs-unstable.zsh}/bin/zsh
        dragon --target | while read dst
        do
          cp "''${dst//file:\/\//}" .
        done
      '';
      executable = true;
    };

    stateVersion = "23.11";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
