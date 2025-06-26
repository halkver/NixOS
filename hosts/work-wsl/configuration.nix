{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  security.pki.certificateFiles = [ ../../zscaler.crt ];

  networking.hostName = "work-wsl";

  wsl.enable = true;
  wsl.defaultUser = "halkver";

  boot.loader.systemd-boot.enable = false;

  system.stateVersion = "24.11";
}

