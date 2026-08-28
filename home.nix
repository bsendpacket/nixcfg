{ ... }:
let
  channels = (import ./channels.nix).channels;
  pkgs = channels.nixpkgs-unstable;

  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";

  colorscheme = import ./colorscheme.nix;
in
{
  imports = [
    channels.nixvim.homeModules.nixvim

    # Git
    (import ./git/git.nix { inherit channels; })

    # Terminal Setup
    (import ./kitty/kitty.nix { inherit channels colorscheme; })
    (import ./yazi/yazi.nix { inherit channels colorscheme; })
    (import ./zsh/zsh.nix { inherit channels colorscheme; })
    (import ./neovim/neovim.nix { inherit channels homeDirectory; })
    (import ./zoxide/zoxide.nix { inherit channels; })
  ];

  programs.home-manager = {
    enable = true;
    path = "${pkgs.home-manager.src}";
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;

    packages = (with pkgs; [
      # Nix-specific tools
      nurl
      nix-init

      # Shell
      oh-my-zsh
      zsh-fast-syntax-highlighting

      man-pages
      man-pages-posix

      git
      (hiPrio bat)
      _7zz
      ouch
      unar
      htop
      fastfetch
      glow

      # Navigation / search
      lsd
      zoxide
      fzf
      fd
      ripgrep
      jq
      jless
      hexyl
      file
      channels.nixpkgs-unstable-feb-2025.yazi

      # Yazi preview dependencies
      ffmpegthumbnailer
      mediainfo
      exiftool
      poppler

      # Build tools
      # NOTE: on macOS the C/C++ compiler comes from the Xcode Command Line
      # Tools (`xcode-select --install`), which is also what the nixpkgs
      # darwin stdenv uses. Only the extras are installed here.
      cmake
      gnumake
      pkg-config
      nasm
      rustup

      # Fonts
      nerd-fonts.caskaydia-cove
    ]);

    sessionVariables = {
      EDITOR = "nvim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };

    sessionPath = [ "$HOME/.local/bin" ];

    stateVersion = "23.11";
  };
}
