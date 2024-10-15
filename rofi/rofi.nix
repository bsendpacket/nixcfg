{ config, nixpkgs-unstable, nixpkgs-stable, ... }: {

  programs.rofi = {
    enable = true;
    terminal = "${nixpkgs-stable.contour}/bin/contour";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
