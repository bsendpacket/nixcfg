{ lib, fetchFromGitHub, dotnetCorePackages, buildDotnetModule }:

buildDotnetModule {
  pname = "NETReactorSlayer";
  version = "6.4";

  src = fetchFromGitHub {
    owner = "SychicBoy";
    repo = "NETReactorSlayer";
    rev = "0d0a631124e8871f1e69c68be342db6fa45cf37d";
    hash = "sha256-sphpZtzV13+MQbV0dC4RueZ91NlegchCPSnHXnp3Cy0=";
  };

  projectFile = "NETReactorSlayer.CLI/NETReactorSlayer.CLI.csproj";

  nugetDeps = ./deps.nix;
  buildType = "Release";
  selfContainedBuild = true;

  executables = [ "NETReactorSlayer.CLI" ];
  runtimeIds = [ "linux-x64" ];

  dotnetFlags = [
    "/p:TargetFramework=netcoreapp3.1"
    "/p:RuntimeIdentifier=linux-x64"
    "/p:IncludeNativeLibrariesForSelfExtract=true"
    "/p:PublishTrimmed=true"
    "/p:PublishSingleFile=true"
  ];

  buildPhase = ''
    runHook preBuild
    dotnet publish --no-restore -c Release $dotnetFlags $projectFile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib/NETReactorSlayer
    cp bin/Release/netcoreapp3.1/linux-x64/publish/NETReactorSlayer.CLI $out/lib/NETReactorSlayer/
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/NETReactorSlayer/NETReactorSlayer.CLI $out/bin/NETReactorSlayer --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1
  '';

  meta = with lib; {
    description = "An open source (GPLv3) deobfuscator and unpacker for Eziriz .NET Reactor";
    homepage = "https://github.com/SychicBoy/NETReactorSlayer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bsendpacket ];
  };
}
