{ channels, customPackages, workConfig, nixGLPrefix, colorscheme, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtra = ''
      # Place any values that need to be handled by ~/.zshrc here, if they cannot be defined elsewhere

      source ${../python/activate_envs.sh}

      unset LD_LIBRARY_PATH
      unset QT_PLUGIN_PATH

      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$HOME/idapro-8.4:$PATH"

      ## PyEnv Setup
      if command -v pyenv &> /dev/null; then
        eval "$(pyenv init -)"
      fi

      ## Binary Refinery Setup
      function alias-noglob {
          while read -r entrypoint; do
              alias $entrypoint="noglob $entrypoint"
          done
      }

      python <<EOF | alias-noglob
      from importlib.metadata import entry_points

      eps = entry_points(group='console_scripts')
      refinery_eps = [ep.name for ep in eps if ep.module.startswith('refinery')]

      for ep_name in refinery_eps:
          print(ep_name)
      EOF

      ## ZSH Vi Bindings
      zvm_bindkey vicmd _ beginning-of-line
      zvm_bindkey vicmd '^R' fzf_history_search
      zvm_bindkey vicmd ':' undefined-key

      zvm_bindkey viins '^[^?' backward-kill-word

      ZVM_KEYTIMEOUT=0
      ZVM_ESCAPE_KEYTIMEOUT=0
      ZVM_VI_HIGHLIGHT_BACKGROUND=${colorscheme.colors.cursor}
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
      yara = "${channels.nixpkgs-unstable.yara-x}/bin/yr";
      netreactorslayer = "${customPackages.net-reactor-slayer}/bin/NETReactorSlayer";
      rbat = "${customPackages.binary-refinery}/bin/bat";
      goresym = "${channels.nixpkgs-unstable.goresym}/bin/GoReSym";
      ilspy = "${channels.nixpkgs-unstable.avalonia-ilspy}/bin/ILSpy";

      # OpenGL Required
      kitty = "${nixGLPrefix}kitty";
      alacritty = "${nixGLPrefix}alacritty";
      contour = "${nixGLPrefix}contour";
    } // (workConfig.programs.zsh.shellAliases or {});

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
      plugins = [ "git" "thefuck" ];
    };
  };
}
