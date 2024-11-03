{ channels, customPackages, binaryNinjaEnv, ... }:

let
  # Helper to set up a Python venv
  makePythonEnv = { name, packages }:
    let
      pythonEnv = channels.nixpkgs-unstable.python312.withPackages (ps: packages ps);
    in
    {
      name = name;
      pythonEnv = pythonEnv;
    };

  # Virtual Environment Setup
  speakeasyEnv = makePythonEnv {
    name = "speakeasy";
    packages = ps: with ps; [
      # Every venv _must_ have Python declared!
      python

      # Python packages from nixchannels.nixpkgs-unstable
      requests
      construct
      urllib3

      # Custom packages from home.nix
      customPackages.speakeasy
    ];
  };

  binjaEnv = {
    name = "binja";
    pythonEnv = binaryNinjaEnv;
  };

in
{
  envs = [
    speakeasyEnv
    binjaEnv
  ];
}
