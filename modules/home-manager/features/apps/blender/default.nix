{ pkgs, ... }:
{
  unfreePackages = [ "blender" "optix" "cuda_cudart" "cuda_nvcc" "cuda_cccl" ];

  # Add Blender (CUDA Support)
  home.packages = [
    (pkgs.blender.override { cudaSupport = true; })
  ];
}