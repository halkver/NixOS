{ config, pkgs, ... }:
{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = "hmeen";

  boot.loader.systemd-boot.enable = false;

  system.stateVersion = "24.11";
}
