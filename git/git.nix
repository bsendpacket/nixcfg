{ channels ... }: {

  programs.git = {
    enable = true;
    package = channels.nixpkgs-unstable.git;

    userName = "";
    userEmail = "";
  };

}
