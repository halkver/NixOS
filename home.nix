{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixCats.homeModule
    ./modules/nvim
  ];
  home = {
    username = "halkver";
    homeDirectory = "/home/halkver";
    stateVersion = "24.11";
    sessionVariables.EDITOR = "vim";

    packages = with pkgs; [
      nerd-fonts.fira-code
    ];

  };

  programs = {
    ripgrep.enable = true;
    bat.enable = true;
    eza.enable = true;

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
      plugins = with pkgs.fishPlugins; [
        {
          name = "tide";
          src = tide.src;
        }
      ];
    };

    fzf =
      let
        fzf-preview = inputs.fzf-preview.packages.${pkgs.system}.default;
      in
      {
        enable = true;
        enableFishIntegration = true;
        defaultOptions = [
          "--layout=reverse"
          "--height=40%"
        ];
        fileWidgetOptions = [
          "--preview '${lib.getExe fzf-preview} {}'"
        ];
        changeDirWidgetOptions = [
          "--preview 'eza --tree --color=always {} | head -200'"
        ];
        historyWidgetOptions = [
          "--sort"
          "--exact"
        ];
      };
  };
}
