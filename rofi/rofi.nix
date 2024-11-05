{ channels, config, ... }: {

  programs.rofi = {
    enable = true;
    package = channels.nixpkgs-unstable.rofi;

    terminal = "${channels.nixpkgs-unstable.contour}/bin/contour";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
