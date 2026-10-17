#!/usr/bin/env bash
# packages/meltype/mozc-pin.json を、flake.lock で固定している Meltype の native/mozc/MOZC_COMMIT に合わせて書き換える。
#   packages/meltype/update-mozc-pin.sh            いまのシステム (x86_64-linux など) の vendorHash を計算する
#   packages/meltype/update-mozc-pin.sh --force    MOZC_COMMIT が同じでも計算し直す (nixpkgs の Bazel の更新などで
#                                                  vendorHash が合わなくなったとき)
#
# 先に `nix flake update meltype` で Meltype を更新しておくこと。
# vendorHash は Bazel が取ってくるツール (Python など) がシステムごとに違うので、システムごとに要る。
# ほかのシステムの分は、そのシステムの上でこのスクリプトを実行すると足される。
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
flake="$(cd "$here/../.." && pwd)"
pinFile="$here/mozc-pin.json"
fakeHash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

force=0
[[ "${1:-}" == "--force" ]] && force=1

system="$(nix eval --raw --impure --expr builtins.currentSystem)"

# flake の input の Meltype から MOZC_COMMIT を読む
meltypeSrc="$(nix eval --raw --impure --expr "(builtins.getFlake \"path:$flake\").inputs.meltype.outPath")"
commit="$(tr -d '[:space:]' < "$meltypeSrc/native/mozc/MOZC_COMMIT")"
echo "MOZC_COMMIT: $commit"

oldCommit="$(nix eval --raw --impure --expr "(builtins.fromJSON (builtins.readFile $pinFile)).commit")"
oldVendorHash="$(nix eval --raw --impure --expr "(builtins.fromJSON (builtins.readFile $pinFile)).vendorHash.\"$system\" or \"\"")"
if [[ "$commit" == "$oldCommit" && -n "$oldVendorHash" && "$force" == 0 ]]; then
    echo "mozc-pin.json は最新です ($system)。計算し直すときは --force を付けてください。"
    exit 0
fi

# Mozc のソースのハッシュ (fetchFromGitHub と同じ、展開したもののハッシュ)
if [[ "$commit" == "$oldCommit" ]]; then
    hash="$(nix eval --raw --impure --expr "(builtins.fromJSON (builtins.readFile $pinFile)).hash")"
else
    echo "Mozc のソースを取得しています..."
    hash="$(nix flake prefetch --json "github:google/mozc/$commit" \
        | nix eval --raw --impure --expr '(builtins.fromJSON (builtins.readFile /dev/stdin)).hash')"
fi
echo "hash: $hash"

# 書き込む: 同じ commit ならほかのシステムの vendorHash は残し、違うなら捨てる
writePin() { # $1 = この system の vendorHash
    nix eval --raw --impure --expr "
      let
        old = builtins.fromJSON (builtins.readFile $pinFile);
        keep = if old.commit == \"$commit\" then old.vendorHash or { } else { };
      in
      builtins.toJSON {
        commit = \"$commit\";
        hash = \"$hash\";
        vendorHash = keep // { \"$system\" = \"$1\"; };
      }" | nix run nixpkgs#jq -- --indent 2 . > "$pinFile.tmp"
    mv "$pinFile.tmp" "$pinFile"
}

# vendorHash: 偽のハッシュで vendor の FOD をビルドし、エラーに出る正しいハッシュを拾う
writePin "$fakeHash"
echo "Bazel の依存を取得して vendorHash を計算しています ($system)..."
log="$(nix build --no-link --impure --expr "
  let
    flake = builtins.getFlake \"path:$flake\";
    pkgs = flake.inputs.stable.legacyPackages.\"$system\";
    helper = pkgs.callPackage $here/mozc-helper.nix { src = flake.inputs.meltype; };
  in
  helper.vendorStage1
" 2>&1 || true)"
vendorHash="$(grep -oE 'got: +sha256-[A-Za-z0-9+/=]+' <<< "$log" | awk '{print $2}' | tail -n1)"
if [[ -z "$vendorHash" ]]; then
    echo "$log" >&2
    echo "vendorHash を取得できませんでした (上のログを確認してください)。" >&2
    writePin "${oldVendorHash:-$fakeHash}"
    exit 1
fi
echo "vendorHash: $vendorHash"
writePin "$vendorHash"
echo "更新しました: $pinFile"
