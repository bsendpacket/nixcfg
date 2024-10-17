# Run this shell.nix with 'nix-shell' to obtain a TypeScript Frida dev environment
{}:
let
  channels = (import ../channels.nix).channels;
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
      echo "Make a .ts file, and put '/// <reference types="frida-gum" />' on the first line."
    '';
  }


