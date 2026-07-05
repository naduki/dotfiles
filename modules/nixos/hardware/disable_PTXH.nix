{ pkgs, ...}:
{
  # Fix for KVM switch (e.g., MSI Modern MD272QPW) preventing sleep.
  # PTXH must be disabled in /proc/acpi/wakeup to allow the system to suspend properly.
  systemd.services.disable-acpi-wakeup-PTXH = {
    description = "Disable PTXH in /proc/acpi/wakeup for KVM switch compatibility";
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'if grep -q \"PTXH.*enabled\" /proc/acpi/wakeup; then echo PTXH > /proc/acpi/wakeup; fi'";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };
}