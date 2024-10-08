{ ... }: {
  # Enable Picom service to enable transparacy
  services.picom = {
    enable = true;

    activeOpacity = 0.95;
    inactiveOpacity = 0.8;
    vSync = true;

    opacityRules = [ "100:class_g *?= 'Rofi'" ];

    settings = {
      corner-radius = 8;
    };
  };
}
