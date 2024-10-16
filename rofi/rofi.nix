{ channels, config, ... }: {

  programs.rofi = {
    enable = true;
    terminal = "${channels.nixpkgs-unstable.contour}/bin/contour";
    #terminal = "${channels.nixpkgs-unstable.alacritty}/bin/alacritty";
    theme = "${config.xdg.configHome}/home-manager/rofi/theme.rasi";
  };
}
