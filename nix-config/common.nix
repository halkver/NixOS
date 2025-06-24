{ config, pkgs, inputs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  programs = {
    fish.enable = true;

    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };

    git = {
      enable = true;
      config = {
        user.name = "Halvor Kvernes Meen";
        user.email = "halvorkm@pm.me";
	push = { autoSetupRemote = true; };
	pull = { rebase = true; };
      };
    };
  };

  users.users.hmeen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      hmeen = import ./home.nix;
    };
  };
}
