{ pkgs, customPackages, ... }: {

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtra = ''
      # Place any values that need to be handled by ~/.zshrc here, if they cannot be defined elsewhere

      unset LD_LIBRARY_PATH
      unset QT_PLUGIN_PATH

      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$HOME/idapro-8.4:$PATH"

      if command -v pyenv &> /dev/null; then
        eval "$(pyenv init -)"
      fi

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
      kitty = "nixGL kitty";
      alacritty = "nixGL alacritty";
      contour = "nixGL contour";
      netreactorslayer = "${customPackages.net-reactor-slayer}/bin/NETReactorSlayer";
      rbat = "${customPackages.binary-refinery}/bin/bat";
      goresym = "${pkgs.goresym}/bin/GoReSym";
      ilspy = "${pkgs.avalonia-ilspy}/bin/ILSpy";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "powerlevel10k-config";
        src = ./powerlevel10k;
        file = "p10k.zsh";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
    };
  };

}
