{ lib, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:

buildDotnetModule {
  pname = "de4dot";
  version = "3.1.41592.3405";

  src = fetchFromGitHub {
    owner = "de4dot";
    repo = "de4dot";
    rev = "b7d5728fc0c82fb0ad758e3a4c0fbb70368a4853";
    hash = "sha256-f0G3vVg0NZcx0RqWwDNmLZ9FqMVekDCml1jkXgUWMZc=";
    fetchSubmodules = true;
  };

  projectFile = "de4dot-x64/de4dot-x64.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  buildType = "Release";
  selfContainedBuild = true;
  executables = [ "de4dot-x64" ];

  runtimeIds = [ "linux-x64" ];

  dotnetFlags = [
    "/p:De4DotNetFramework=false"
    "/p:TargetFramework=netcoreapp3.1"
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
