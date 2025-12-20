{ pkgs ? import <nixpkgs> {}, ... }:
(pkgs.buildFHSEnv {
  name = "AUTOMATIC1111/stable-diffusion-webui FHS Environment";

  # OSにNvidiaドライバと固有環境でBlender CUDAを入れたためか、
  # FHSだとドライバとCUDAを無くすことができた
  targetPkgs = pkgs: with pkgs; [
    git # The program instantly crashes if git is not present, even if everything is already downloaded
    wget
    # python
    python310
    # Other packages
    # stdenv.cc.cc.lib
    stdenv.cc
    libGLU libGL
    glib
    # 無くても動くけどエラーが出る
    freeglut
    util-linux
  ];

  unshareUser = false;
  unshareIpc = false;
  unsharePid = false;
  unshareNet = false;
  unshareUts = false;
  unshareCgroup = false;
  dieWithParent = true;
}).env