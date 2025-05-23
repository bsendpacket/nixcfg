{ channels, colorscheme, ... }: {

  programs.kitty = {
    enable = true;

    font = {
      size = 11.0;
      name = "CaskaydiaCove NFM Light";
    };

    shellIntegration.enableZshIntegration = true;

    settings = {
      # Colors
      background = colorscheme.colors.background;
      foreground = colorscheme.colors.foreground;
      cursor = colorscheme.colors.cursor;
      selection_background = colorscheme.colors.selection;
      selection_foreground = colorscheme.colors.selection_text;

      color0 = colorscheme.colors.black;
      color1 = colorscheme.colors.red;
      color2 = colorscheme.colors.blue;
      color3 = colorscheme.colors.n_purple_3;
      color4 = colorscheme.colors.n_pink_8;
      color5 = colorscheme.colors.purple;
      color6 = colorscheme.colors.n_pink_5;
      color7 = colorscheme.colors.white;
      color8 = colorscheme.colors.bright_black;
      color9 = colorscheme.colors.bright_red;
      color10 = colorscheme.colors.bright_green;
      color11 = colorscheme.colors.bright_yellow;
      color12 = colorscheme.colors.bright_blue;
      color13 = colorscheme.colors.bright_purple;
      color14 = colorscheme.colors.bright_cyan;
      color15 = colorscheme.colors.bright_white;
      color16 = colorscheme.colors.pastel_purple;
      color17 = colorscheme.colors.pastel_pink;

      # Cursor shape
      cursor_shape = "block";

      # No terminal bell sound
      enable_audio_bell = "false";

      # Set the shell to zsh
      shell = "${channels.nixpkgs-unstable.zsh}/bin/zsh";

      window_padding_width = 0;
    };
  };
}
