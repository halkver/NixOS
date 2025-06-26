{ config, pkgs, ... }: {
  home = {
    username = "halkver";
    homeDirectory = "/home/halkver";
    stateVersion = "24.11";

    packages = [
      pkgs.nerd-fonts.fira-code
    ];
  };

  programs = {
    ripgrep.enable = true;
    bat.enable = true;

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
	  user = "git";
	  port = 443;
	  hostname = "ssh.github.com";
	};
      };
    };

    fish = {
      enable = true;
      shellAliases = {
        rb = "sudo nixos-rebuild switch --flake ~/NixOS/.";
      };
      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = false;
      # defaultOptions = [ "--layout=reverse" "--height=40%" ];
      # fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers {}'" ];
    };
  };
}
