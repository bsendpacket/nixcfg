# Run this shell.nix with 'nix-shell' to enter a TypeScript Frida dev environment
{ homeDir ? builtins.getEnv "HOME" }:
let
  channels = (import "${homeDir}/.config/home-manager/channels.nix").channels;
in
  channels.nixpkgs-unstable.mkShell {
    buildInputs = with channels.nixpkgs-unstable; [
      nodejs
      typescript
    ];

    shellHook = ''
      npm install @types/frida-gum
      npm install typescript

      echo "You are now ready to use Frida!"
      echo "Make a .ts file, and put '// <reference types="frida-gum" />' on the first line."
      echo "You can then run 'frida -H 192.168.XXX.X:27042 -f C:\\<path_to_malware> -l <frida_script>.ts'"
    '';
  }
