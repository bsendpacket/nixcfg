{ config, pkgs, ... }: {

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.contour}/bin/contour";
    #terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
