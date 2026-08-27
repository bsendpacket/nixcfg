{ channels, colorscheme, ... }:
{
  programs.zsh = {
    enable = true;
    package = channels.nixpkgs-unstable.zsh;

    autosuggestion.enable = true;
    enableCompletion = true;

    initContent = ''
      # Place any values that need to be handled by ~/.zshrc here, if they cannot be defined elsewhere

      # ~/.zprofile runs `brew shellenv` *after* home-manager's ~/.zshenv, which
      # prepends /opt/homebrew/bin and shadows the nix profile (most visibly, a
      # brew-installed nvim wins over the nixvim build). .zshrc is sourced last,
      # so re-prepend here. `typeset -U` keeps this idempotent across re-sourcing.
      typeset -U path PATH
      path=("$HOME/.nix-profile/bin" $path)
      export PATH

      ## ZSH Vi Bindings
      zvm_bindkey vicmd _ beginning-of-line
      zvm_bindkey vicmd '^R' fzf_history_search
      zvm_bindkey vicmd ':' undefined-key

      zvm_bindkey viins '^[^?' backward-kill-word

      ZVM_KEYTIMEOUT=0
      ZVM_ESCAPE_KEYTIMEOUT=0
      ZVM_VI_HIGHLIGHT_BACKGROUND=${colorscheme.colors.cursor}

      export COLORTERM=truecolor
    '';

    shellAliases = {
      py = "python3";
      ls = "lsd";       # LSDeluxe
      cd = "z";         # Zoxide
      l = "ls -l";      # List Files
      la = "ls -a";
      lla = "ls -la";   # List Files (+ Hidden)
      lt = "ls --tree"; # List Files (Tree)
      y = "yy";         # Yazi
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = channels.nixpkgs-unstable.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-fzf-history-search";
        src = channels.nixpkgs-unstable.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.zsh";
      }
      {
        name = "zsh-vi-mode";
        src = channels.nixpkgs-unstable.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = channels.nixpkgs-unstable.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions";
      }
      {
        name = "powerlevel10k-config";
        src = ./powerlevel10k;
        file = "p10k.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      package = channels.nixpkgs-unstable.oh-my-zsh;

      plugins = [ "git" ];
    };
  };
}
