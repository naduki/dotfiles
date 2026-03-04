{ pkgs ? import <nixpkgs> {}, ... }:
(pkgs.buildFHSEnv {
  name = "AUTOMATIC1111/stable-diffusion-webui FHS Environment";

  # It seems that because the Nvidia driver and Blender CUDA were installed on the host OS,
  # they could be omitted from this FHS environment.
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
    # Works without it, but errors occur
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