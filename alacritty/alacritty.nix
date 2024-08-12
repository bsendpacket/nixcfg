{ pkgs, colorscheme, ... }: {

  programs.alacritty = {
    enable = true;
    settings = {

      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          background = "${colorscheme.colors.background}";
          foreground = "${colorscheme.colors.foreground}";
        };

        cursor = {
          cursor = "${colorscheme.colors.cursor}";
          text = "${colorscheme.colors.background}";
        };

        selection = {
          background = "${colorscheme.colors.selection}";
          text = "${colorscheme.colors.selection_text}";
        };

        normal = {
          black = "${colorscheme.colors.black}";
          red = "${colorscheme.colors.red}";
          green = "${colorscheme.colors.blue}";
          yellow = "${colorscheme.colors.n_purple_3}";
          blue = "${colorscheme.colors.n_pink_8}";
          magenta = "${colorscheme.colors.purple}";
          cyan = "${colorscheme.colors.n_pink_5}";
          white = "${colorscheme.colors.white}";
        };

        bright = {
          black = "${colorscheme.colors.bright_black}";
          red = "${colorscheme.colors.bright_red}";
          green = "${colorscheme.colors.bright_green}";
          yellow = "${colorscheme.colors.bright_yellow}";
          blue = "${colorscheme.colors.bright_blue}";
          magenta = "${colorscheme.colors.bright_purple}";
          cyan = "${colorscheme.colors.bright_cyan}";
          white = "${colorscheme.colors.bright_white}";
        };

        indexed_colors = [
          { index = 16; color = "${colorscheme.colors.pastel_purple}"; }
          { index = 17; color = "${colorscheme.colors.pastel_pink}"; }
        ];
      };

      window = {
        padding = { x = 0; y = 0; };
      };

      shell = { 
        program = "${pkgs.zsh}/bin/zsh";
      };

      cursor = {
        style = {
          shape = "Block";
        };
      };

      bell = {
        duration = 0;
      };

      hints = {
        enabled = [
          {
            mouse = {
              enabled = false;
            };
            hyperlinks = false;
            action = "Select";
            regex = "";
          }
        ];
      };

    };
  };
}
