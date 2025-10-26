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

# To update:
# 1) Clone the repo
# 2) Remake the patch diffs
# 3) nix-shell -p pnpm
# 4) pnpm install --no-frozen-lockfile
# 5) git add *
# 6) git diff --staged > ./fix-dependency.patch
# 7) Ensure esbuild version matches
stdenv.mkDerivation (finalAttrs: {
  pname = "webcrack";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "j4k0xb";
    repo = "webcrack";
    rev = "32cbd0604af9ba4930f4594cdcfea799d6cf1e81";
    hash = "sha256-1tsVu/uXtX6p+ZhwKiJoa6AoXIBdeK0XcMYcHGaScRU=";
  };

  patches = [ ./fix-dependency.patch ];

  # Download all pnpm packages declaratively based off the pnpm-lock.yaml file
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-B2QFlEf4t4XenxfwDyl7waVV7VXEkIMLmHh+sArfu0E=";
    fetcherVersion = 2;
    optional = true;
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    makeWrapper
    python3
    nodePackages.node-gyp # Required for isolated-vm build
  ];

  # We specifically need version 0.25.2 of esbuild
  env = {
    ESBUILD_BINARY_PATH = "${lib.getExe (
      esbuild.override {
        buildGoModule =
          args:
          buildGoModule (
            args
            // rec {
              version = "0.25.2";
              src = fetchFromGitHub {
                owner = "evanw";
                repo = "esbuild";
                rev = "v${version}";
                hash = "sha256-aDxheDMeQYqCT9XO3In6RbmzmXVchn+bjgf3nL3VE4I=";
              };
            }
          );
      }
    )}";
  };

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

    # Copy the built package
    cp -r packages/webcrack/dist $out/lib/webcrack/
    cp packages/webcrack/package.json $out/lib/webcrack/

    # Copy production node_modules
    cp -rL node_modules $out/lib/webcrack/

    makeWrapper ${nodejs}/bin/node $out/bin/webcrack \
      --set NODE_PATH "$out/lib/webcrack/node_modules" \
      --add-flags "$out/lib/webcrack/dist/cli.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Deobfuscate obfuscator.io, unminify and unpack bundled javascript";
    homepage = "https://github.com/j4k0xb/webcrack";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "webcrack";
    platforms = [ "x86_64-linux" ];
  };
})
