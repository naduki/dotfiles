# Meltype の fcitx5 のアドオン。
# linux/build.sh の「2/3 fcitx5 のアドオン」と linux/install.sh の fcitx5 の部分に相当する。
#
# 出力の配置:
#   $out/lib/fcitx5/meltype.so                  アドオン本体 (fcitx5 が読む)
#   $out/share/fcitx5/addon/meltype.conf        アドオンの定義
#   $out/share/fcitx5/inputmethod/meltype.conf  入力メソッドの定義 (@DIR@ を置き換え済み)
#   $out/lib/meltype/                           MELTYPE_DIR (install.sh の /opt/meltype に相当)
#     libMeltypeNative.so, icon.png, mozc/meltype_mozc_helper, LICENSE, ...
#
# MELTYPE_DIR は CMakeLists.txt の CACHE 変数なので、-DMELTYPE_DIR=... で渡せる (ソースの書き換えは要らない)。
{
  lib,
  stdenv,
  callPackage,
  cmake,
  pkg-config,
  fcitx5,
  src,
  withMozc ? true,
  meltype-native ? callPackage ./native.nix { inherit src; },
  meltype-mozc-helper ? if withMozc then callPackage ./mozc-helper.nix { inherit src; } else null,
}:
assert withMozc -> meltype-mozc-helper != null;
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-meltype";
  version = callPackage ./version.nix { inherit src; };
  inherit src;

  sourceRoot = "source/linux/fcitx5";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ fcitx5 ];

  cmakeFlags = [
    (lib.cmakeFeature "MELTYPE_DIR" "${placeholder "out"}/lib/meltype")
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/share/fcitx5/addon/keyboard.conf" "${fcitx5}/share/fcitx5/addon/keyboard.conf"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    HOME="$(mktemp -d)" MELTYPE_DIR="${meltype-native}/lib" ctest --output-on-failure
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
  + ''
    runHook postInstall
  '';

  passthru = {
    inherit meltype-native meltype-mozc-helper;
  };

  meta = {
    description = "Meltype input method addon for fcitx5";
    homepage = "https://github.com/yksr-melt/Meltype";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
})
