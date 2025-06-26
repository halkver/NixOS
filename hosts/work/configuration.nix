{ config, pkgs, ... }:
let
  netConfig = builtins.fromJSON (builtins.readFile ./netconf.json);
in
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "work";
  # networking.wireless.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp86s0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = netconf.ip;
        prefixLength = netconf.prefixLength;
      }
    ];
  };
  networking.defaultGateway = netconf.defaultGateway;
  networking.nameservers = netconf.nameservers;

  security.pki.certificateFiles = [ ../../zscaler.crt ];
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh.enable = true;


  programs.hyprland.enable = true;

  programs.firefox.enable = true;

  system.stateVersion = "25.05";
}
