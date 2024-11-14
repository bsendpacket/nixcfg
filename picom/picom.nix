{ channels, ... }: {
  # Enable Picom service to enable transparency and blur
  services.picom = {
    enable = true;
    package = channels.nixpkgs-unstable.picom;

    backend = "glx";

    activeOpacity = 0.95;
    inactiveOpacity = 0.8;
    vSync = true;

    opacityRules = [ "100:class_g *?= 'Rofi' || class_g *?= 'Firefox'" ];

    settings = {
      blur-kern = "3x3box";
      blur = {
        method = "kernel";
        strength = 8;
        background = false;
        background-frame = false;
        background-fixed = false;
        kern = "3x3box";
      };

      # Exclude windows from blur
      blur-background-exclude = [
        "window_type = 'desktop'"
        "class_g = 'Rofi'"
        "class_g = 'Firefox'"
      ];
    };
  };
}

