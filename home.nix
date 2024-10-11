{
  config,
  lib,
  ...
}:
let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  shell = builtins.getEnv "SHELL";
  isNixOS = builtins.pathExists "/etc/NIXOS";

  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });

  colorscheme = import ./colorscheme.nix;

  # Force the same interpreter version
  # Allows Python packages from stable to be used on unstable
  pythonInterpreterOverlay = self: super: {
    python312 = pkgs.python312;
  };

  stablePkgs = import <nixpkgs-stable> { 
    overlays = [ pythonInterpreterOverlay ];
  };

  # Fix Python package issues
  pythonOverlay = self: super: {
    python312Packages = super.python312Packages.override {
      overrides = pythonSelf: pythonSuper: {

        # The NixPkg for angr uses protobuf4, although it works with protobuf5
        # By forcing protobuf5 here, conflicts of multiple versions existing is prevented
        protobuf = pythonSuper.protobuf5;

        # Stable unicorn is required for angr at the moment
        unicorn = stablePkgs.python312Packages.unicorn;

        pyvex = pythonSuper.pyvex.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "pyvex";
            version = version;
            sha256 = "sha256-pMGjUHGu/cxFqQb0It8/ZRzy+l3zJ0r8vsCO5TMbvrY=";
          };
        });

        archinfo = pythonSuper.archinfo.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "archinfo";
            version = version;
            sha256 = "sha256-zlXHn9sXqA460dOAjnq6tEaIsKPU/nh+IKHCPX9RVhY=";
          };
        });

        claripy = pythonSuper.claripy.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "claripy";
            version = version;
            sha256 = "sha256-DTX7ktnreH4d8J+7e+vutZbvClxO4Hb4NuicM+enZjY=";
          };
        });
          
        cle = pythonSuper.cle.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "cle";
            version = version;
            sha256 = "sha256-FJ2nt3krfY8y24cukto3KeQrq6mJHJMiK9WEe4R65Wo=";
          };
        });

        ailment = pythonSuper.ailment.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "ailment";
            version = version;
            sha256 = "sha256-B5aSEQYs3B6RzlQmkOeEnvdgrkSDlJIFC+KHU4eN/6k=";
          };
        });

        # Fix version mismatch on NixPkgs Unstable and suppress broken state
        angr = pythonSuper.angr.overrideAttrs (oldAttrs: rec {
          version = "9.2.120";

          src = pythonSelf.fetchPypi {
            pname = "angr";
            version = version;
            sha256 = "sha256-CGHE2sJVPlAJ6mBcmtuR3k7MvMBkBgppOH4tVPmewuA=";
          };

          meta = oldAttrs.meta // {
            broken = false;
          };
        });
      };
    };
  };

  # Some packages are broken in unstable, use the stable versions instead
  stableOverlay = self: super: {
    contour = stablePkgs.contour;
  };

  pkgs = import <nixpkgs> {
    overlays = [ pythonOverlay stableOverlay ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;

      # Add NUR packages
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };

  binaryNinjaURL = import ./binary-ninja/binary-ninja-url.nix;
  binaryNinjaConfig = import ./binary-ninja/config.nix { inherit pkgs; };

  # Packages to build, as they are not on NixPkgs
  customPackages = {
    jadx = pkgs.callPackage ./jadx/default.nix { };
    de4dot = pkgs.callPackage ./de4dot/de4dot.nix { };
    redress = pkgs.callPackage ./redress/redress.nix { };
    webcrack = pkgs.callPackage ./webcrack/webcrack.nix { };
    frida-tools = pkgs.callPackage ./dependencies/frida-tools.nix { };
    decompylepp = pkgs.callPackage ./decompylepp/decompylepp.nix { };
    detect-it-easy = pkgs.callPackage ./detect-it-easy/detect-it-easy.nix { };
    net-reactor-slayer = pkgs.callPackage ./net-reactor-slayer/net-reactor-slayer.nix { };

    # Python Packages
    capa = pkgs.callPackage ./capa/capa.nix { };
    speakeasy = pkgs.callPackage ./speakeasy/speakeasy.nix { };
    binary-refinery = pkgs.callPackage ./binary-refinery/binary-refinery.nix { };
    donut-decryptor = pkgs.callPackage ./donut-decryptor/donut-decryptor.nix { };
    dncil = pkgs.callPackage ./dependencies/dncil.nix { };

    binary-ninja = pkgs.callPackage ./binary-ninja/binary-ninja.nix { 
      binaryNinjaUrl = binaryNinjaURL.binaryNinjaUrl;
      binaryNinjaHash = binaryNinjaURL.binaryNinjaHash;
      pythonEnv = binaryNinjaConfig.pythonEnv;
    };
  };

  # Work-specific
  fileExists = path: if builtins.pathExists path then import path { inherit pkgs lib; } else {};
  workConfig = fileExists ./work/work.nix;
in
{
  # Apply overlays globally
  nixpkgs.overlays = pkgs.overlays;

  imports = [
    nixvim.homeManagerModules.nixvim

    # Window Manager
    (import ./i3/i3.nix { inherit pkgs config lib homeDirectory shell isNixOS; })

    # Git
    (import (if builtins.pathExists ./work/git/git.nix then ./work/git/git.nix else ./git/git.nix))

    # Terminal Setup 
    (import ./tmux/tmux.nix { inherit pkgs; })
    (import ./kitty/kitty.nix { inherit pkgs colorscheme; })
    (import ./alacritty/alacritty.nix { inherit pkgs colorscheme; })
    (import ./yazi/yazi.nix { inherit pkgs config colorscheme workConfig isNixOS; })
    (import ./zsh/zsh.nix { inherit lib pkgs customPackages workConfig; })
    (import ./neovim/neovim.nix { inherit pkgs homeDirectory; })
    (import ./rofi/rofi.nix { inherit config pkgs; })
    (import ./contour/settings.nix { inherit config lib pkgs; })
    (import ./contour/contour.nix { inherit lib pkgs colorscheme; })

    ./zoxide/zoxide.nix
    ./zathura/zathura.nix
    ./malwoverview/malwoverview.nix

    # Services
    ./picom/picom.nix

    binaryNinjaConfig.binaryNinjaConfig

    # Program Setup
    (import ./firefox/firefox.nix { inherit pkgs lib; })
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = (with pkgs // customPackages; [

      # VM tools
      open-vm-tools

      # Backup File Manager
      nautilus

      # Touchpad
      libinput-gestures
      wmctrl
      xdotool

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

      zig
      rustup

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
        frida-python
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

      # podman is broken on nix at the moment, if not on NixOS
      # podman
      # podman-tui
      # podman-compose

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
