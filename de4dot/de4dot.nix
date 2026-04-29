{ lib, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:

buildDotnetModule {
  pname = "de4dot";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "GDATAAdvancedAnalytics";
    repo = "de4dotEx";
    rev = "f20ace72a90c7cbfab68ff720860cf70a0458ebb";
    hash = "sha256-PCExo6XkDA5WvaWKeopn+aLOQ1aL2rIICNg9/scHvYo=";
    fetchSubmodules = true;
  };

  projectFile = "de4dot-x64/de4dot-x64.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  buildType = "Release";
  selfContainedBuild = true;
  executables = [ "de4dot-x64" ];

  runtimeIds = [ "linux-x64" ];

  dotnetFlags = [
    "/p:De4DotNetFramework=false"
    "/p:TargetFramework=net8.0"
  ];

  postFixup = ''
    makeWrapper $out/bin/de4dot-x64 $out/bin/de4dot --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1
  '';

  meta = with lib; {
    description = ".NET deobfuscator and unpacker.";
    homepage = "https://github.com/de4dot/de4dot";
    license = licenses.gpl1Plus;
    platforms = platforms.linux;
    maintainers = [ "bsendpacket" ];
  };
}
