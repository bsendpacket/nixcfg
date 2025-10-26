{ channels, ... }: {

  programs.git = {
    enable = true;
    package = channels.nixpkgs-unstable.git;

    settings.user = {
      name = "";
      email = "";
    };
  };

}
