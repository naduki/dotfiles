{pkgs, ...}:
{
  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # waylandFrontend = true;
      addons = with pkgs; [ fcitx5-mozc ];
    };
  };
}
