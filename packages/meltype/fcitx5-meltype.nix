# Meltype の fcitx5 のアドオン。
# linux/build.sh の「2/3 fcitx5 のアドオン」と linux/build-deb.sh (build-rpm.sh) の配置に相当する。
#
# 出力の配置:
#   $out/lib/fcitx5/meltype.so                  アドオン本体 (fcitx5 が読む)
#   $out/share/fcitx5/addon/meltype.conf        アドオンの定義
#   $out/share/fcitx5/inputmethod/meltype.conf  入力メソッドの定義 (@DIR@ を置き換え済み)
#   $out/lib/meltype/                           MELTYPE_DIR (deb・rpm の /opt/meltype に相当)
#     libMeltypeNative.so, icon.png, mozc/meltype_mozc_helper, meltype-settings, LICENSE, ...
#   $out/bin/meltype-settings                   設定画面 (withSettings のとき。deb の /usr/bin/meltype-settings)
#   $out/share/applications/meltype-settings.desktop
#
# MELTYPE_DIR は CMakeLists.txt の CACHE 変数なので、-DMELTYPE_DIR=... で渡せる (ソースの書き換えは要らない)。
# fcitx5 の設定ツールの「設定」は、MELTYPE_DIR/meltype-settings を起動する (meltype.cpp の ExternalOption)。
{
  lib,
  stdenv,
  callPackage,
  cmake,
  pkg-config,
  fcitx5,
  python3,
  gtk4,
  gobject-introspection,
  wrapGAppsHook4,
  src,
  meltype-native ? callPackage ./native.nix { inherit src; },
  meltype-mozc-helper ? if withMozc then callPackage ./mozc-helper.nix { inherit src; } else null,
  withMozc ? true,
  # 設定画面 (meltype-settings, Python・GTK 4)。1.5.0 から
  withSettings ? true,
}:
assert withMozc -> meltype-mozc-helper != null;
let
  # deb の Depends (python3, python3-gi, gir1.2-gtk-4.0) に相当する
  settingsPython = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-meltype";
  version = callPackage ./version.nix { inherit src; };
  inherit src;

  sourceRoot = "source/linux/fcitx5";

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withSettings [
    gobject-introspection
    wrapGAppsHook4
  ];
  buildInputs = [
    fcitx5
  ]
  ++ lib.optionals withSettings [
    # patchShebangs が #!/usr/bin/env python3 をこの python に置き換える
    settingsPython
    gtk4
  ];

  # wrapGAppsHook4 は既定では $out/bin などしか包まない。設定画面だけを postFixup で包む。
  dontWrapGApps = true;

  cmakeFlags = [
    (lib.cmakeFeature "MELTYPE_DIR" "${placeholder "out"}/lib/meltype")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/share/fcitx5/addon/keyboard.conf" "${fcitx5}/share/fcitx5/addon/keyboard.conf"
  '';

  nativeCheckInputs = lib.optionals withSettings [ python3 ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    HOME="$(mktemp -d)" MELTYPE_DIR="${meltype-native}/lib" ctest --output-on-failure
  ''
  + lib.optionalString withSettings ''
    # 設定画面の config.json の読み書き (GTK は使わない。CI の linux.yml と同じ)
    python3 "$NIX_BUILD_TOP/$sourceRoot/../tests/test_settings.py"
  ''
  + ''
    runHook postCheck
  '';

  # CMakeLists.txt に install() が無いので、自分で配置する。
  installPhase = ''
    runHook preInstall

    meltypeDir="$out/lib/meltype"
    linuxDir="$NIX_BUILD_TOP/$sourceRoot/.."
    rootDir="$linuxDir/.."

    install -Dm755 meltype.so "$out/lib/fcitx5/meltype.so"
    install -Dm644 "$linuxDir/fcitx5/meltype-addon.conf" "$out/share/fcitx5/addon/meltype.conf"
    install -dm755 "$out/share/fcitx5/inputmethod"
    substitute "$linuxDir/fcitx5/meltype.conf" "$out/share/fcitx5/inputmethod/meltype.conf" \
      --replace-fail "@DIR@" "$meltypeDir"

    install -dm755 "$meltypeDir"
    ln -s "${meltype-native}/lib/libMeltypeNative.so" "$meltypeDir/libMeltypeNative.so"
    install -Dm644 "$linuxDir/icon.png" "$meltypeDir/icon.png"
    install -Dm644 "$rootDir/LICENSE" "$meltypeDir/LICENSE"
    install -Dm644 "$rootDir/THIRD-PARTY-NOTICES.md" "$meltypeDir/THIRD-PARTY-NOTICES.md"
  ''
  + lib.optionalString withMozc ''
    ln -s "${meltype-mozc-helper}/lib/meltype/mozc" "$meltypeDir/mozc"
  ''
  + lib.optionalString withSettings ''
    install -Dm755 "$linuxDir/meltype-settings" "$meltypeDir/meltype-settings"
    install -dm755 "$out/bin"
    ln -s "$meltypeDir/meltype-settings" "$out/bin/meltype-settings"
    # deb は GNOME の IBus 用に ibus-setup-meltype.desktop の名前で入れる。fcitx5 では
    # アプリの一覧から開くためのものなので、名前を変えて入れる。
    install -dm755 "$out/share/applications"
    substitute "$linuxDir/ibus-setup-meltype.desktop" "$out/share/applications/meltype-settings.desktop" \
      --replace-fail "Exec=@DIR@" "Exec=$meltypeDir" \
      --replace-fail "Icon=@DIR@" "Icon=$meltypeDir"
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString withSettings ''
    wrapGApp "$out/lib/meltype/meltype-settings"
  '';

  passthru = {
    inherit meltype-native meltype-mozc-helper;
  };

  meta = {
    description = "Meltype input method addon for fcitx5";
    homepage = "https://github.com/yksr-melt/Meltype";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "meltype-settings";
  };
})
