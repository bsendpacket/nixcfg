{ pkgs, binary-refinery, ... }: {

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    initExtra = ''
      # Place any values that need to be handled by ~/.zshrc here, if they cannot be defined elsewhere

      unset LD_LIBRARY_PATH

      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"

      if command -v pyenv &> /dev/null; then
        eval "$(pyenv init -)"
      fi
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
      rbat = "${binary-refinery}/bin/bat";
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
