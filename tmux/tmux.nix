{ pkgs, ... }: {

  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set -g status-style bg=default
      set -g default-terminal "tmux-256color"
      set -as terminal-overrides ',xterm*:Tc:smxx=\E[9m:rmxx=\E[23m'

      bind -n C-h resize-pane -L 2   # Hold Ctrl + h to resize left
      bind -n C-j resize-pane -D 2   # Hold Ctrl + j to resize down
      bind -n C-k resize-pane -U 2   # Hold Ctrl + k to resize up
      bind -n C-l resize-pane -R 2   # Hold Ctrl + l to resize right
    '';
  };
}
