{
  config,
  lib,
  ...
}:
let
  channels = (import ./channels.nix).channels;

  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  isNixOS = builtins.pathExists "/etc/NIXOS";
  colorscheme = import ./colorscheme.nix;
  nixGLPrefix = if isNixOS then "" else "${channels.nixpkgs-unstable.nixGL.auto.nixGLDefault}/bin/nixGL ";

  binaryNinjaURL = import ./binary-ninja/binary-ninja-url.nix;
  binaryNinjaConfig = import ./binary-ninja/config.nix { 
    inherit channels binaryNinjaURL;
  };

  # Packages to build, as they are not on NixPkgs
  customPackages = {
    # .NET
    de4dot = channels.nixpkgs-unstable.callPackage ./de4dot/de4dot.nix { };
    net-reactor-slayer = channels.nixpkgs-unstable.callPackage ./net-reactor-slayer/net-reactor-slayer.nix { };

    # NPM/PNPM
    webcrack = channels.nixpkgs-unstable.callPackage ./webcrack/webcrack.nix { };

    # C++
    decompylepp = channels.nixpkgs-unstable.callPackage ./decompylepp/decompylepp.nix { };

    # Python
    capa = channels.nixpkgs-unstable.python312Packages.callPackage ./capa/capa.nix { };
    binary-refinery = channels.nixpkgs-unstable.python312Packages.callPackage ./binary-refinery/binary-refinery.nix { };
    donut-decryptor = channels.nixpkgs-unstable.python312Packages.callPackage ./donut-decryptor/donut-decryptor.nix { };
    pyja3 = channels.nixpkgs-unstable.python312Packages.callPackage ./dependencies/pyja3.nix { };
    ucutils = channels.nixpkgs-unstable.python312Packages.callPackage ./dependencies/ucutils.nix { };
    icicle-emu = channels.nixpkgs-unstable.python312Packages.callPackage ./dependencies/icicle-emu.nix { };

    binary-ninja = channels.nixpkgs-unstable.callPackage ./binary-ninja/binary-ninja.nix {
      inherit channels;
      binaryNinjaUrl = binaryNinjaURL.binaryNinjaUrl;
      binaryNinjaHash = binaryNinjaURL.binaryNinjaHash;
      pythonEnv = binaryNinjaConfig.pythonEnv;
    };

    libtriton = channels.nixpkgs-unstable.python312Packages.callPackage ./dependencies/triton.nix { 
      z3 = channels.nixpkgs-unstable.z3;
      boost = channels.nixpkgs-unstable.boost;
      libffi = channels.nixpkgs-unstable.libffi;
      libxml2 = channels.nixpkgs-unstable.libxml2;
      bitwuzla = channels.nixpkgs-unstable.bitwuzla;
      capstone = channels.nixpkgs-unstable.capstone;
      llvmPackages_16 = channels.nixpkgs-unstable-feb-2025.llvmPackages_16;
    };
  };

  # Python Environments
  pythonEnvs = import ./python/venvs.nix { inherit channels customPackages; binaryNinjaEnv = binaryNinjaConfig.pythonEnv; };

  # Work-Specific
  # Certain folders can be kept off the Git tree, but can still be imported into the config.
  fileExists = path: if builtins.pathExists path then import path { inherit channels lib; } else {};
  workConfig = fileExists ./work/work.nix;

in
{
  imports = [
    channels.nixvim.homeModules.nixvim

    # Window Manager
    (import ./i3/i3.nix { inherit channels config lib nixGLPrefix; })

    # Git
    (import (if builtins.pathExists ./work/git/git.nix then ./work/git/git.nix else ./git/git.nix) { inherit channels; } )

    # Terminal Setup 
    (import ./yazi/yazi.nix { inherit channels config colorscheme workConfig nixGLPrefix; })
    (import ./zsh/zsh.nix { inherit lib channels customPackages workConfig nixGLPrefix colorscheme; })
    (import ./neovim/neovim.nix { inherit channels homeDirectory; })
    (import ./rofi/rofi.nix { inherit channels config; })
    (import ./contour/settings.nix { inherit channels config lib; })
    (import ./contour/contour.nix { inherit channels lib colorscheme; })
    (import ./zoxide/zoxide.nix { inherit channels; })

    ./zathura/zathura.nix

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
      spice-vdagent

      # Nix-specific tools
      nurl
      nix-init

      # Window Manager
      i3
      i3status-rust

      # Terminal
      contour

      # Shell
      oh-my-zsh
      zsh-fast-syntax-highlighting

      man-pages
      man-pages-posix

      git
      _7zz
      (hiPrio bat)
      ouch
      htop

      fastfetch
      glow

      obsidian

      lxqt.screengrab

      ffmpeg

      # Required by neovim's LspInfo
      gcc

      # Web
      # Unwrapped version defined in firefox/firefox.nix
      #firefox
      
      # Utilities
      xclip
      xsel
      xdragon
      jless
      unar

      lsd
      zoxide
      fzf
      fd
      ripgrep
      jq
      hexyl
      channels.nixpkgs-unstable-feb-2025.yazi

      rofi

      ffmpegthumbnailer
      mediainfo
      exiftool
      unar
      file
      poppler

      # Fonts
      pkgs.nerd-fonts.caskaydia-cove

      ## Malware Analysis
        
      # Binary Analysis
      detect-it-easy
      binary-ninja
      flare-floss
      ghidra
      imhex
      capa
      upx

      yara-x
      yaralyzer

      # Family-Specific
      donut-decryptor

      # Networking
      wireshark

      # JavaScript
      webcrack

      # Java
      jadx

      # .NET
      ilspycmd
      de4dot
      net-reactor-slayer

      # Go
      goresym

      # Python
      decompylepp

      # Android
      apktool

      # Custom Python environment
      (channels.nixpkgs-unstable.python312.withPackages (ps: with channels.nixpkgs-unstable.python312Packages; [
        # Networking
        requests
        flask
        netifaces
        pyja3

        # Binary Analysis
        binary-refinery
        frida-python
        construct
        construct-typing
        arrow

        # .NET
        dnfile
        dncil

        # Emulation / Symbolic Execution
        icicle-emu
        libtriton
        angr
        miasm

        # Disassembly/Assembly
        capstone
        keystone-engine

        unicorn
        ucutils

        lief
      ] ++ (workConfig.home.pythonPackages or [])))
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
        Exec=${homeDirectory}/.nix-profile/bin/i3
        Type=Application
      '';
      executable = false;
    };

    file.".local/bin/DRAG_TO_VM" = {
      text = ''
        #!${channels.nixpkgs-unstable.zsh}/bin/zsh
        xdragon --target | while read dst
        do
          cp "''${dst//file:\/\//}" .
        done
      '';
      executable = true;
    };

    stateVersion = "23.11";
  };
}
