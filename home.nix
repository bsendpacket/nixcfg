{
  config,
  lib,
  ...
}:
let
  # Force the same interpreter version
  # Allows Python packages from stable to be used on unstable
  pythonInterpreterOverlay = self: super: {
    python312 = channels.nixpkgs-unstable.python312;
  };

  # Some packages are broken in unstable, use the stable versions instead
  stableOverlay = self: super: {
    contour = channels.nixpkgs-stable.contour;
  };

  # Fix Python package issues
  pythonOverlay = self: super: {
    python312Packages = super.python312Packages.override {
      overrides = pythonSelf: pythonSuper: {

        # The NixPkg for angr uses protobuf4, although it works with protobuf5
        # By forcing protobuf5 here, conflicts of multiple versions existing is prevented
        protobuf = pythonSuper.protobuf5;

        # Stable unicorn is required for angr at the moment
        unicorn = channels.nixpkgs-stable.python312Packages.unicorn;

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

  channels = {
    nixpkgs-stable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
      sha256 = "0j15vhfz4na8wmvp532jya81y06g74qkr25ci58dp895bw7l9g2q";
    }) {
      system = "x86_64-linux";
      overlays = [ pythonInterpreterOverlay ];
      config.allowUnfree = true;
    };

    nixpkgs-unstable = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "1wn29537l343lb0id0byk0699fj0k07m1n2d7jx2n0ssax55vhwy";
    }) {
      system = "x86_64-linux";
      overlays = [ pythonOverlay stableOverlay customOverlay ];
        
      config.allowUnfree = true;
      config.packageOverrides = pkgs: {
        nur = channels.nur;
      };
    };

    home-manager = builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      sha256 = "1lfjr640fkb7152djxvy2db1g9fqxj5hfrgjgri9b21xn3nq7992";
    };

    # NUR and nixvim overlays
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
      sha256 = "0mdavhf8ing8f7s928xs796k2s1c64awh8cyv0gidj6k1zbcywq6";
    }) { pkgs = channels.nixpkgs-unstable; };

    nixvim = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixvim/archive/main.tar.gz";
      sha256 = "0ww9hmimkfmnxj9ji8ik4s1rkidjfkwg4vxfrqmfrrqd8rpij3c1";
    });
  };

  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  shell = builtins.getEnv "SHELL";
  isNixOS = builtins.pathExists "/etc/NIXOS";

  colorscheme = import ./colorscheme.nix;

  # stablePkgs = import <nixpkgs-stable> { 
  #   overlays = [ pythonInterpreterOverlay ];
  # };



  customOverlay = self: super: {

    # Innoextract with custom patch to allow for extracting CompiledCode.bin file
    innoextract = super.innoextract.overrideAttrs (oldAttrs: {
      version = "1.10-dev-patched";

      src = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "dscharrer";
        repo = "innoextract";
        rev = "264c2fe6b84f90f6290c670e5f676660ec7b2387";
        hash = "sha256-DLQ1gphCr4haaBppAJh+zyg0ObjHzO9xLFgHpRb1f0Y=";
      };
      
      patches = [ ./innoextract/extract_compiled_code.patch ];
    });
  };

  # pkgs = import <nixpkgs> {
  #   overlays = [ pythonOverlay stableOverlay customOverlay ];
  #   config = {
  #     allowUnfree = true;
  #     allowUnfreePredicate = _: true;
  #
  #     # Add NUR packages
  #     packageOverrides = pkgs: {
  #       nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #         inherit channels;
  #       };
  #     };
  #   };
  # };

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
    (import ./i3/i3.nix { inherit channels config lib homeDirectory shell isNixOS; })

    # Git
    (import (if builtins.pathExists ./work/git/git.nix then ./work/git/git.nix else ./git/git.nix))

    # Terminal Setup 
    (import ./tmux/tmux.nix { inherit channels; })
    (import ./kitty/kitty.nix { inherit channels colorscheme; })
    (import ./alacritty/alacritty.nix { inherit channels colorscheme; })
    (import ./yazi/yazi.nix { inherit channels config colorscheme workConfig isNixOS; })
    (import ./zsh/zsh.nix { inherit lib channels customPackages workConfig; })
    (import ./neovim/neovim.nix { inherit channels homeDirectory; })
    (import ./rofi/rofi.nix { inherit channels config; })
    (import ./contour/settings.nix { inherit channels config lib; })
    (import ./contour/contour.nix { inherit channels lib colorscheme; })

    ./zoxide/zoxide.nix
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
    path = "${channels.home-manager}";
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
}
