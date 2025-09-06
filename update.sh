#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git newt
# shellcheck shell=sh
# This script is used to update NixOS / Home-manager.

# If "-h" option is specified, display usage
[ "$1" = "-h" ] && usage 0

# Clean up environment variables and functions
close(){
  unset DIR MODE LOOP_FLAG USER HOSTNAME
  unset -f usage nixos home canceled os_failed hm_failed
  exit "$1"
}
# Define functions for error handling
canceled() { echo "Cancelled."; close 1; }
os_failed() { echo "NixOS update failed."; close 3; }
hm_failed() { echo "Home-manager update failed."; close 4; }
# Usage output function
usage() {
  echo -e "\nUsage: $(basename "$0") [mode]"
  echo "Modes:"
  echo " -f   Update Flake.lock"
  echo " -fc  Update Flake.lock and commit flake.lock"
  echo " -os  Update NixOS"
  echo " -hm  Update Home-manager"
  close "$1"
}
ttyclear() { [ -z "$DISPLAY" ] && clear; }
# NixOS update function
nixos(){
  # Select arguments to pass to nixos-rebuild with whiptail
  MODE=$(whiptail --title "NixOS Update Mode" --menu "Choose NixOS update mode:" 15 80 4 \
    "switch" "Switch to the new configuration" \
    "boot"   "Apply new configuration at next startup" \
    "test"   "Test the new configuration" \
    "build-vm" "Build and launch a VM image" \
    3>&1 1>&2 2>&3) || return 0
  ttyclear
  # Execute process according to mode
  case "$MODE" in
    (switch)
      echo -e "\nSwitching to the new configuration..."
      # nixos-rebuild switch --upgrade --use-remote-sudo --flake .#"$USER"@"$HOSTNAME"
      nixos-rebuild switch --sudo --flake .#"$USER"@"$HOSTNAME" || os_failed ;;
    (boot)
      echo -e "\nApplying new configuration at next startup..."
      nixos-rebuild boot --sudo --flake .#"$USER"@"$HOSTNAME" || os_failed ;;
    (test)
      echo -e "\nTesting the new configuration..."
      nixos-rebuild test --sudo --flake .#"$USER"@"$HOSTNAME" || os_failed ;;
    (build-vm)
      echo -e "\nBuilding and launching a VM image..."
      nixos-rebuild build-vm --flake .#"$USER"@"$HOSTNAME" || os_failed
      QEMU_OPTS="-display gtk" ./result/bin/run-"$HOSTNAME"-vm ;;
  esac
}
# Home-manager update function
home(){
  # Select arguments to pass to home-manager with whiptail
  MODE=$(whiptail --title "Home-manager standalone Update Mode" --menu "Choose Home-manager standalone update mode:" 15 80 3 \
    "activate" "Activate home-manager standalone" \
    "switch" "Switch to the new configuration" \
    "build"  "Build the new configuration" \
    3>&1 1>&2 2>&3) || return 0
  ttyclear
  # Execute process according to mode
  case "$MODE" in
    (activate)
      echo -e "\nActivating home-manager standalone..."
      nix run flake:home-manager -- switch --flake .#"$USER" || hm_failed ;;
    (switch)
      echo -e "\nSwitching to the new configuration..."
      home-manager switch --flake .#"$USER" || hm_failed ;;
    (build)
      echo -e "\nBuilding the new configuration..."
      home-manager build --flake .#"$USER" || hm_failed ;;
  esac
}
# Main section
# Get username and hostname
USER=$(id -un 2>/dev/null || logname 2>/dev/null || whoami 2>/dev/null || echo "unknown")
HOSTNAME=$(hostname 2>/dev/null || echo "unknown-host")
# If unknown or unknown-host, display error message
if [ "$USER" = "unknown" ] || [ "$HOSTNAME" = "unknown-host" ]; then
  echo "Error: Unable to determine user or hostname."
  close 2
fi
# Change to the directory where this script is located
cd "$(dirname "$0")" || close 1
# Check if flake.nix exists, otherwise input directory with whiptail
if [ ! -f "flake.nix" ]; then
  DIR=$(whiptail --title "Flake Directory" --inputbox "Enter the directory containing flake.nix:" 10 60 3>&1 1>&2 2>&3) || canceled
  ttyclear
  cd "$DIR" || close 2
fi
# Infinite loop
while true; do
  # If no arguments, select operation mode with whiptail
  if [ $# -eq 0 ]; then
    MODE=$(whiptail --title "Update Mode" --menu "Choose update mode:" 15 60 5 \
      "f"  "Update Flake.lock" \
      "fc" "Update Flake.lock (Commit)" \
      "os" "Update NixOS" \
      "hm" "Update Home-manager standalone" \
      "q"  "Quit" \
      --clear 3>&1 1>&2 2>&3) || canceled
    ttyclear
    LOOP_FLAG=true
  else
    # If arguments exist, remove hyphen and set mode
    MODE=$(echo "$1" | sed 's/^-//')
    LOOP_FLAG=false
  fi
  # Execute process according to mode
  case "$MODE" in
    (f)
      echo -e "\nUpdating Flake.lock..."
      nix flake update ;;
    (fc)
      echo -e "\nUpdating Flake.lock and committing..."
      nix flake update --commit-lock-file ;;
    (os)
      nixos ;;
    (hm)
      home ;;
    (q)
      LOOP_FLAG=false ;;
    (*)
      echo "Invalid mode: $MODE"
      usage 2
      ;;
  esac
  # If loop flag is "false", break the loop
  ${LOOP_FLAG} || break
  sleep 3
done
