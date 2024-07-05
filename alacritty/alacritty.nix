{ pkgs, ... }: {

  programs.alacritty = {
    enable = true;
    settings = {

      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          background = "#080808";
          foreground = "#bdbdbd";
          bright_foreground = "#eeeeee";
        };

        cursor = {
          cursor = "#8e8e8e";
          text = "#080808";
        };

        selection = {
          background = "#b2ceee";
          text = "#080808";
        };

        normal = {
          black = "#323437";
          blue = "#80a0ff";
          cyan = "#79dac8";
          green = "#8cc85f";
          magenta = "#cf87e8";
          red = "#ff5454";
          white = "#c6c6c6";
          yellow = "#e3c78a";
        };

        bright = {
          black = "#949494";
          blue = "#74b2ff";
          cyan = "#85dc85";
          green = "#36c692";
          magenta = "#ae81ff";
          red = "#ff5189";
          white = "#e4e4e4";
          yellow = "#c6c684";
        };
      };

      window = {
        title = "Terminal";
        padding = { y = 5; };
        
        dimensions = {
          lines = 75;
          columns = 100;
        };
      };

      font = {
        normal.family = "CaskaydiaCove Nerd Font Mono";
        size = 11.0;
      };

      shell = { 
        program = "${pkgs.zsh}/bin/zsh";
      };

    };
  };
}
