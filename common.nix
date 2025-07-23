{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  networking.networkmanager.enable = true;

  fonts.fontconfig.enable = true;

  programs = {
    ssh.startAgent = true;
    fish.enable = true;

    git = {
      enable = true;
      config = {
        user.name = "Halvor Kvernes Meen";
        user.email = "halvorkm@pm.me";
        push = {autoSetupRemote = true;};
        pull = {rebase = true;};
        init = {defaultBranch = "main";};
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
  };

  users.users.halkver = {
    initialPassword = "haru";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;
  };

  security.sudo.extraRules = [
    {
      users = ["halkver"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.localBinInPath = true;
}
