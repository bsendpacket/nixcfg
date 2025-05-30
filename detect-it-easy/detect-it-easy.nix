{ lib
, stdenv
, fetchurl
, qt5
, freetype
, icu
, krb5
, systemd
, imagemagick
}:

stdenv.mkDerivation rec {
  pname = "detect-it-easy";
  version = "3.10";

  src = fetchurl {
    url = "https://github.com/horsicq/DIE-engine/releases/download/${version}/die_sourcecode_${version}.tar.gz";
    sha256 = "sha256-TLQexBs6NDPf/AcczYr9kcvGnDP76lT53ZRwVaXsS1w=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
    imagemagick
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtscript
    qt5.qtsvg
    qt5.qttools
    freetype
    icu
    krb5
    systemd
  ];

  qmakeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preBuild = ''
    for subdir in build_libs gui_source console_source lite_source; do
      pushd $subdir
      qmake PREFIX=$out $subdir.pro
      make clean
      make -j2
      popd
    done

    pushd gui_source
    lrelease gui_source_tr.pro
    popd
  '';

  installPhase = ''
    mkdir -p $out/{bin,opt/${pname},share/pixmaps,share/applications}
    cp build/release/{die,diec,diel} $out/opt/${pname}/

    cp -r gui_source/translation $out/opt/${pname}/lang
    cp -r XStyles/qss $out/opt/${pname}/
    cp -r XInfoDB/info $out/opt/${pname}/
    cp -r XYara/yara_rules $out/opt/${pname}/
    cp -r Detect-It-Easy/db $out/opt/${pname}/
    cp -r Detect-It-Easy/db_custom $out/opt/${pname}/
    install -Dm644 signatures/crypto.db $out/opt/${pname}/signatures/crypto.db
    cp -r images $out/opt/${pname}/

    ln -s $out/opt/${pname}/die $out/bin/die
    ln -s $out/opt/${pname}/diec $out/bin/diec
    ln -s $out/opt/${pname}/diel $out/bin/diel

    install -Dm644 LINUX/hicolor/48x48/apps/detect-it-easy.png $out/share/pixmaps/detect-it-easy.png
    install -Dm644 LINUX/die.desktop $out/share/applications/die.desktop

    install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
  '';

  meta = with lib; {
    description = "Detect It Easy (DiE) is a powerful tool for file type identification, popular among malware analysts, cybersecurity experts and reverse engineers worldwide.";
    homepage = "https://horsicq.github.io";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "die";
    maintainers = with maintainers; [ bsendpacket ];
  };
}
