# Meltype のバージョンを src/Meltype.Core/Meltype.Core.csproj の <Version> から読む。
# 読めなければ "unstable" にする (ビルド自体は止めない)。
{ lib, src }:
let
  csproj = builtins.readFile "${src}/src/Meltype.Core/Meltype.Core.csproj";
  m = builtins.match ".*<Version>([^<]+)</Version>.*" csproj;
in
if m == null then "unstable" else lib.head m
