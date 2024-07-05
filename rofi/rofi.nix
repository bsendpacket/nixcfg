{ config, pkgs, ... }: {

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
