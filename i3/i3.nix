{ channels, config, lib, nixGLPrefix, ... }: 
let 
  tmuxWrapper = channels.nixpkgs-unstable.writeShellScriptBin "tmux-main" ''
    #!${channels.nixpkgs-unstable.bash}/bin/bash
    if ! ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 has-session -t main 2>/dev/null; then
      # First time: create session and use its initial window
      exec ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 new-session -s main
    fi
    # Not first time: create new window and use that
    WINDOW_INDEX=$(${channels.nixpkgs-unstable.tmux}/bin/tmux -2 new-window -d -P -t main -F "#{window_index}")
    exec ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 new-session -t main \; select-window -t $WINDOW_INDEX
  '';

  scratchWrapper = channels.nixpkgs-unstable.writeShellScriptBin "tmux-scratch" ''
    #!${channels.nixpkgs-unstable.bash}/bin/bash
    if ! ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 has-session -t scratch 2>/dev/null; then
      ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 new-session -d -s scratch
    fi
    exec ${nixGLPrefix}${channels.nixpkgs-unstable.contour}/bin/contour --class scratchpad ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 attach -t scratch
  '';

  modifier = "Mod1";
  # Main terminal
  terminal = "${nixGLPrefix}${channels.nixpkgs-unstable.contour}/bin/contour ${tmuxWrapper}/bin/tmux-main";

  # Scratch terminal (Just to quickly run some commands)
  scratchTerminal = "${scratchWrapper}/bin/tmux-scratch";

  # Create a new tmux session
  newSessionCmd = ''${nixGLPrefix}${channels.nixpkgs-unstable.contour}/bin/contour ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 new-session -s'';

  # Open a terminal with a given tmux session
  attachSessionCmd = ''${nixGLPrefix}${channels.nixpkgs-unstable.contour}/bin/contour ${channels.nixpkgs-unstable.tmux}/bin/tmux -2 attach -t'';
in {
  xsession = {
    windowManager.i3 = {
      enable = true;
      package = channels.nixpkgs-unstable.i3;

      config = {

        defaultWorkspace = "workspace number 1";

        # Mod+Enter opens the terminal under the 'main' tmux session
        terminal = terminal;

        bars = [{ 
          command = "${channels.nixpkgs-unstable.i3}/bin/i3bar";
          statusCommand = "${channels.nixpkgs-unstable.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-i3bar.toml";
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

          # Create new tmux session
          "${modifier}+Shift+s" = "exec ${channels.nixpkgs-unstable.rofi}/bin/rofi -dmenu -p 'New Session Name' | xargs -r ${newSessionCmd}";

          # Attach to existing tmux session
          "${modifier}+s" = "exec ${channels.nixpkgs-unstable.tmux}/bin/tmux list-sessions | ${channels.nixpkgs-unstable.rofi}/bin/rofi -i -dmenu | cut -d: -f1 | xargs -r ${attachSessionCmd}";

          # Attach to the scratch terminal
          #"${modifier}+Escape" = "exec --no-startup-id ${scratchTerminal}; exec --no-startup-id i3-msg floating enable, resize set 1200 700, move position center";
          "${modifier}+Escape" = "[class=scratchpad] scratchpad show";

          # Vim-like keybindings for i3
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Shift+c" = "reload";

          # Rofi
          "${modifier}+d" = "exec --no-startup-id ${channels.nixpkgs-unstable.zsh}/bin/zsh -c 'LANG=en_US.UTF-8 LC_ALL=C PATH=~/.nix-profile/bin:$PATH ${channels.nixpkgs-unstable.rofi}/bin/rofi -show run'";
          "${modifier}+Shift+w" = "exec --no-startup-id ${channels.nixpkgs-unstable.zsh}/bin/zsh -c 'LANG=en_US.UTF-8 LC_ALL=C ${channels.nixpkgs-unstable.rofi}/bin/rofi -show window'";

          # Floating window toggle
          #"${modifier}+Escape" = "scratchpad show";
          "${modifier}+space" = "floating toggle";

          # Laptop function keys
          "XF86AudioMute" = "exec pamixer -t";
          "XF86AudioLowerVolume" = "exec pamixer --decrease 5";
          "XF86AudioRaiseVolume" = "exec pamixer --increase 5";
          "XF86MonBrightnessUp" = "exec brightnessctl set +2%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";
        };
      };

      extraConfig = ''
        # Launch the scratchpad at logon
        exec --no-startup-id ${scratchTerminal}

        # Configure scratchpad window
        for_window [class="scratchpad"] border none
        for_window [class="scratchpad"] floating enable
        for_window [class="scratchpad"] resize set 1200 700
        for_window [class="scratchpad"] move position center
        for_window [class="scratchpad"] move scratchpad

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
        exec --no-startup-id libinput-gestures
        exec --no-startup-id nm-applet
        exec --no-startup-id vmware-user
        exec --no-startup-id vmware-user-suid-wrapper
      '';
    };
  };

  programs.i3status-rust = {
    enable = true;
    package = channels.nixpkgs-unstable.i3status-rust;

    bars.i3bar = {
      icons = "awesome5";
      theme = "native";
      blocks = [
        {
          block = "focused_window";
          format = " $title.str(max_w:75) |";
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
          block = "battery";
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
