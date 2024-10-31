{ channels, ... }: {

  programs.zoxide = {
    enable = true;
    package = channels.nixpkgs-unstable.zoxide;
    enableZshIntegration = true;
  };
}
