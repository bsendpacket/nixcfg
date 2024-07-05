{ pkgs, ... }: {

  programs.kitty = {
    enable = true;

    font = {
      size = 11.0;
      name = "CaskaydiaCove Nerd Font Mono";
    };

    shellIntegration.enableZshIntegration = true;

    settings = {
      # Colors
      background = "#080808";
      foreground = "#bdbdbd";
      cursor = "#8e8e8e";
      selection_background = "#b2ceee";
      selection_foreground = "#080808";

      color0 = "#323437";
      color1 = "#ff5454";
      color2 = "#8cc85f";
      color3 = "#e3c78a";
      color4 = "#80a0ff";
      color5 = "#cf87e8";
      color6 = "#79dac8";
      color7 = "#c6c6c6";
      color8 = "#949494";
      color9 = "#ff5189";
      color10 = "#36c692";
      color11 = "#c6c684";
      color12 = "#74b2ff";
      color13 = "#ae81ff";
      color14 = "#85dc85";
      color15 = "#e4e4e4";
      color16 = "#e3c78a";
      color17 = "#cf87e8";

      # Cursor shape
      cursor_shape = "block";

      # No terminal bell sound
      enable_audio_bell = "false";

      # Set the shell to zsh
      shell = "${pkgs.zsh}/bin/zsh";

      window_padding_width = 0;
    };
  };
}
