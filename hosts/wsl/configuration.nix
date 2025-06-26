{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = "halkver";

  boot.loader.systemd-boot.enable = false;

  system.stateVersion = "24.11";
}
