{ config, pkgs, ... }: let
  netconf = builtins.fromJSON (builtins.readFile ./netconf.json);
in {
  imports = [ ./hardware-configuration.nix ./falcon.nix ];

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

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.pki.certificateFiles = [ ../../zscaler.crt ];
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh.enable = true;

  fonts.fontDir.enable = true;

  programs.hyprland = {
    enable = true;
  };

  programs.firefox.enable = true;

  programs.foot = {
    enable = true;
    enableFishIntegration = true;
  };

  system.stateVersion = "25.05";
}
