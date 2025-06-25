{ config, pkgs, ... }: {
  home = {
    username = "halkver";
    homeDirectory = "/home/halkver";
    stateVersion = "24.11";
  };

  programs = {
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
  };
}
