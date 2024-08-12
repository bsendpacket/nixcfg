{ pkgs, config, lib, shell, homeDirectory, ... }: 
let 
  modifier = "Mod1";
in {
  xsession = {
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;

      config = {

        defaultWorkspace = "workspace number 1";

        #terminal = "${homeDirectory}/.nix-profile/bin/nixGL ${pkgs.kitty}/bin/kitty";
        terminal = "${homeDirectory}/.nix-profile/bin/nixGL ${pkgs.alacritty}/bin/alacritty";
        bars = [{ 
          command = "${pkgs.i3}/bin/i3bar";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-i3bar.toml";
          position = "top";
        }];

        window = {
          border = 1;
          titlebar = false;
        };

        floating = {
          border = 0;
          titlebar = false;
        };
        
        fonts = {
          names = ["CaskaydiaCove Nerd Font Mono" "FontAwesome 6"];
          style = "Light Semi-Condensed";
          size = 11.0;
        };

        # TIP: Utilizing `lib.mkOptionDefault` here allows us to keep all the defaults
        # and simply add new keybinds to the configuration.
        keybindings = lib.mkOptionDefault {
          
          # Vim-like keybindings for i3
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+u" = "exec ${pkgs.chromium}/bin/chromium";

          # Rofi
          "${modifier}+d" = "exec --no-startup-id ${shell} -c 'LANG=en_US.UTF-8 LC_ALL=C ${pkgs.rofi}/bin/rofi -show run'";

          # Floating window toggle
          "${modifier}+Escape" = "scratchpad show";
          "${modifier}+space" = "floating toggle";
        };
      };
      extraConfig = ''
        mode "resize" {
          bindsym Up resize shrink height 10 px or 10 ppt
          bindsym Down resize grow height 10 px or 10 ppt
          bindsym Left resize shrink width 10 px or 10 ppt
          bindsym Right resize grow width 10 px or 10 ppt

          bindsym l resize shrink width 10 px or 10 ppt
          bindsym k resize grow height 10 px or 10 ppt
          bindsym j resize shrink height 10 px or 10 ppt
          bindsym h resize grow width 10 px or 10 ppt

          bindsym Escape mode default
          bindsym Return mode default
          bindsym ${modifier}+r mode default
        }

        exec --no-startup-id dex --autostart --environment i3
        exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
        exec --no-startup-id nm-applet
        exec --no-startup-id vmware-user
        exec --no-startup-id vmware-user-suid-wrapper

      '';
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars.i3bar = {
      icons = "awesome5";
      theme = "native";
      blocks = [
        {
          block = "focused_window";
        }
        {
          alert = 10.0;
          block = "disk_space";
          info_type = "available";
          interval = 60;
          path = "/";
          warning = 20.0;
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents ";
          format_alt = " $icon $swap_used_percents ";
        }
        {
          block = "cpu";
          format = " $barchart $utilization $frequency ";
          interval = 1;
        }
        {
          block = "load";
          format = " $icon $1m ";
          interval = 1;
        }
        {
          block = "time";
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          interval = 60;
        }
      ];
    };
  };
}
