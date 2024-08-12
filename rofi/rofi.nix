{ config, pkgs, ... }: {

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    #terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
