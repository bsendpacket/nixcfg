{ lib, pkgs, colorscheme, ... }:

{
  programs.contour = {
    enable = true;

    profiles = {
      main = {
        escape_sandbox = true;
        copy_last_mark_range_offset = 0;
        initial_working_directory = "~";
        shell = "${pkgs.zsh}/bin/zsh";
        show_title_bar = false;
        size_indicator_on_resize = false;
        fullscreen = false;
        maximized = false;
        wm_class = "contour";
        option_as_alt = false;
        terminal_id = "VT525";
        slow_scrolling_time = 100;
        highlight_word_and_matches_on_double_click = true;
        draw_bold_text_with_bright_colors = false;
        vi_mode_highlight_timeout = 300;
        vi_mode_scrolloff = 8;

        bell = {
          sound = "off";
          volume = 0.0;
          alert = true;
        };

        terminal_size = {
          columns = 80;
          lines = 25;
        };

        margins = {
          horizontal = 0;
          vertical = 0;
        };

        history = {
          limit = 1000;
          auto_scroll_on_update = true;
          scroll_multiplier = 3;
        };

        scrollbar = {
          position = "Hidden";
          hide_in_alt_screen = true;
        };

        mouse = {
          hide_while_typing = true;
        };

        permissions = {
          change_font = "ask";
          capture_buffer = "ask";
          display_host_writable_statusline = "deny";
        };

        font = {
          size = 11;
          dpi_scale = 1.5;
          locator = "native";
          builtin_box_drawing = true;
          render_mode = "light";
          strict_spacing = true;

          text_shaping = {
            engine = "native";
          };

          regular = {
            family = "CaskaydiaCove NFM";
            weight = "demilight";
            slant = "normal";

            features = [ ];
          };

          emoji = "emoji";
        };

        cursor = {
          shape = "block";
          blinking = false;
          blinking_interval = 500;
        };

        normal_mode = {
          cursor = {
            shape = "block";
            blinking = false;
            blinking_interval = 500;
          };
        };

        visual_mode = {
          cursor = {
            shape = "block";
            blinking = false;
            blinking_interval = 500;
          };
        };

        status_line = {
          display = "none";
          position = "bottom";
          sync_to_window_title = false;
        };

        background = {
          opacity = 1.0;
          blur = false;
        };

        colors = {
          light = "default";
          dark = "default";
        };

        hyperlink_decoration = {
          normal = "dotted";
          hover = "underline";
        };
      };
    };

    colorSchemes = {
      default = {
        default = {
          draw_bold_text_with_bright_colors = true;
          background = colorscheme.colors.background;
          foreground = colorscheme.colors.foreground;
        };
        cursor = {
          cursor = colorscheme.colors.cursor;
          text = colorscheme.colors.background;
        };

        selection = {
          background = colorscheme.colors.selection;
          text = colorscheme.colors.selection_text;
        };

        normal = {
          black = colorscheme.colors.black;
          red = colorscheme.colors.red;
          green = colorscheme.colors.blue;
          yellow = colorscheme.colors.n_purple_3;
          blue = colorscheme.colors.n_pink_8;
          magenta = colorscheme.colors.purple;
          cyan = colorscheme.colors.n_pink_5;
          white = colorscheme.colors.white;
        };

        bright = {
          black = colorscheme.colors.bright_black;
          red = colorscheme.colors.bright_red;
          green = colorscheme.colors.bright_green;
          yellow = colorscheme.colors.bright_yellow;
          blue = colorscheme.colors.bright_blue;
          magenta = colorscheme.colors.bright_purple;
          cyan = colorscheme.colors.bright_cyan;
          white = colorscheme.colors.bright_white;
        };

        dim = {
          black = colorscheme.colors.bright_black;
          red = colorscheme.colors.bright_red;
          green = colorscheme.colors.bright_green;
          yellow = colorscheme.colors.bright_yellow;
          blue = colorscheme.colors.bright_blue;
          magenta = colorscheme.colors.bright_purple;
          cyan = colorscheme.colors.bright_cyan;
          white = colorscheme.colors.bright_white;
        };
      };
    };

    inputMapping = lib.mkOptionDefault [
      { mods = [ "Control" "Shift" ]; key = "C"; action = "CopySelection"; }
    ];
  };
}

