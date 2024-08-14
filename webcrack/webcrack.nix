{ lib
, fetchFromGitHub
, buildGoModule
, stdenv
, nodejs
, pnpm
, makeWrapper
, esbuild
, python3
, nodePackages
}:

# This derivation was the worst to make so far by a long shot. 
# If anybody good at Nix comes across this and knows how to make it better, please feel free to reach out, I'd really appreciate it
stdenv.mkDerivation (finalAttrs: {
  pname = "webcrack";
  version = "2.14.0";

  # There are patches included in the upstream webcrack repo which I couldn't figure out how to apply without it all breaking in nix, as pnpm.fetchDeps attempts to auto-patch and fails.
  # For now, I've forked the repo and removed the patches and regenerated the lockfile
  src = fetchFromGitHub {
    owner = "bsendpacket";
    repo = "webcrack";
    rev = "1e4acf6c46703d881cae72da63db9bfe2662ec43";
    hash = "sha256-NSmphq/vGIPrHTKSnFwKg+FB3TQXfGUHqv+YdLDbPYQ=";
  };

  # Download all pnpm packages declaratively based off the pnpm-lock.yaml file
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-oa4BZCmlLvhcQbFNzxd+h8Wds5H88yabcA5pVeFpjGg=";
    optional = true;
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    makeWrapper
    python3
    nodePackages.node-gyp # Required for isolated-vm build
  ];

  # We specifically need version 0.21.4 of esbuild
  # NixPkgs only hosts a newer build (0.23.0) at this time
  env.ESBUILD_BINARY_PATH = "${lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.21.4";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-T/qbf6nMORVWD2G/hJtAlUlg7xep7Bw5zZnBvYoL5cQ=";
            };
          }
        );
    }
  )}";

  # Ignore scripts in order to prevent esbuild from failing
  configurePhase = ''
    runHook preConfigure
    cat > .npmrc << EOF
    ignore-scripts=true
    optional=false
    EOF
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    export HOME=$TMPDIR

    pnpm config set store-dir $pnpmDeps

    # Install packages offline, with a frozen lockfile
    # and specifically with hoisting enabled in order to flatten node-packages
    pnpm install --offline --frozen-lockfile --shamefully-hoist

    # Build isolated-vm
    pushd node_modules/isolated-vm
    node-gyp rebuild
    popd

    cd packages/webcrack
    pnpm build
    cd ../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/webcrack $out/bin
    cp -r packages/webcrack/{dist,package.json} $out/lib/webcrack/
    cp -r node_modules $out/lib/webcrack/

    makeWrapper ${nodejs}/bin/node $out/bin/webcrack \
      --set NODE_PATH "$out/lib/webcrack/node_modules" \
      --add-flags "$out/lib/webcrack/dist/cli.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Deobfuscate obfuscator.io, unminify and unpack bundled javascript";
    homepage = "https://github.com/j4k0xb/webcrack";
    license = licenses.mit;
    maintainers = with maintainers; [ bsendpacket ];
    mainProgram = "webcrack";
    platforms = [ "x86_64-linux" ];
  };
})
