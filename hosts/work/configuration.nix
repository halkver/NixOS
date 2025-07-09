{ config, pkgs, ... }: let
  netconf = builtins.fromJSON (builtins.readFile ./netconf.json);
in {
  imports = [ ./hardware-configuration.nix ./falcon.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "work";
    # wireless.enable = true;
    firewall.allowedTCPPorts = [ 22 ];

    # DMP Specific
    useDHCP = false;
    interfaces.enp86s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = netconf.ip;
          prefixLength = netconf.prefixLength;
        }
      ];
    };
    defaultGateway = netconf.defaultGateway;
    nameservers = netconf.nameservers;
  };

  security.pki.certificateFiles = [ ../../zscaler.crt ];
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-bundle.crt";

  # Configure keymap in X11
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

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

  users.users.halkver.openssh.authorizedKeys.keyFiles = [
    ./authorized_keys
  ];
}
