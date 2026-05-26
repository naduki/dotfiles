{ config, lib, inputs, ... }: {
  options = {
    # 独自のオプション「unfreePackages」を定義（文字列のリスト型）
    # リスト型（listOf）は複数ファイルで定義しても自動で1つにマージされます
    unfreePackages_unstable = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of unfree package names to allow";
    };
  };

  config.nixpkgs.overlays = [
    (final: prev: {
      # stable という名前で、inputs.stable からインポートしたパッケージ群を生やす
      unstable = import inputs.unstable {
        inherit (prev.stdenv.hostPlatform) system;
        # config.cudaCapabilities = [ "8.9" ];
        # 各ファイルから集まったリストを元に、一括で判定関数を作る
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages_unstable;
      };
    })
  ];
}