# Meltype の本体 (C# の Meltype.Core を NativeAOT にした libMeltypeNative.so)。
# linux/build.sh の「1/3 本体 (C#, NativeAOT) をビルド」に相当する。
#
# NuGet のパッケージは参照していない (PackageReference が無い) ので、nugetDeps は要らない。
# NativeAOT のコンパイラ (Microsoft.DotNet.ILCompiler など) は nixpkgs の .NET SDK に同梱されている。
{
  lib,
  callPackage,
  buildDotnetModule,
  dotnetCorePackages,
  clang,
  lld,
  zlib,
  icu,
  patchelf,
  src,
}:
buildDotnetModule {
  pname = "meltype-native";
  version = callPackage ./version.nix { inherit src; };
  inherit src;

  projectFile = "src/Meltype.Mac.Native/Meltype.Mac.Native.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  selfContainedBuild = true;
  dotnetFlags = [
    "-p:PublishAot=true"
    "-p:NativeLib=Shared"
    "-p:StripSymbols=true"
  ];
  executables = [ ];

  nativeBuildInputs = [
    clang
    lld
    patchelf
  ];
  buildInputs = [
    zlib
    icu
  ];

  # buildDotnetModule の既定の配置 ($out/lib/meltype-native/) から、必要な .so だけを残す。
  postInstall = ''
    so="$out/lib/meltype-native/MeltypeNative.so"
    if [[ ! -f "$so" ]]; then
      echo "MeltypeNative.so が見つかりません" >&2
      find "$out" >&2
      exit 1
    fi
    mv "$so" "$out/lib/libMeltypeNative.so"
    rm -rf "$out/lib/meltype-native"
  '';

  # InvariantGlobalization が false なので、.NET のランタイムは起動時に ICU (libicuuc.so.*) を dlopen する。
  # NixOS には決まった場所の ICU が無く、見つからないと読み込んだ fcitx5 ごと落ちるので、RUNPATH に足す。
  # (DT_NEEDED に無いので fixup の shrink-rpath で消される。そのため fixup の後で足す)
  postFixup = ''
    patchelf --add-rpath "${lib.getLib icu}/lib" "$out/lib/libMeltypeNative.so"
  '';

  meta = {
    description = "Meltype core library (NativeAOT build of Meltype.Core)";
    homepage = "https://github.com/yksr-melt/Meltype";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
