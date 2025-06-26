{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  security.pki.certificateFiles = [ ../../zscaler.crt ];
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";

  networking.hostName = "work-wsl";

  wsl.enable = true;
  wsl.defaultUser = "halkver";

  boot.loader.systemd-boot.enable = false;

  system.stateVersion = "24.11";
}

