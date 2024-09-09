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
  runtimeIds = [ "linux-x64" ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  dotnetInstallFlags = [
    "-p:TargetFramework=net6.0"
    "-p:RuntimeIdentifier=linux-x64"
    "-p:IncludeNativeLibrariesForSelfExtract=true"
    "-p:PublishTrimmed=true"
    "-p:PublishSingleFile=true"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/lib/NETReactorSlayer
    cp -r ./bin/Release/net6.0/linux-x64/* $out/lib/NETReactorSlayer/
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
