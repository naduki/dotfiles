{
  unfreePackages = [ "cuda_cudart" "cuda_nvcc" "cuda_cccl" "libcublas" ];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
