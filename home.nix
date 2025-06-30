{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixCats.homeModule ];

  home = {
    username = "halkver";
    homeDirectory = "/home/halkver";
    stateVersion = "24.11";

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

    ruff = {
      enable = true;
      settings = {
        line-length = 120;
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
          "--preview '${lib.getExe fzf-preview}' {}"
        ];
        changeDirWidgetCommand = "echo Hello";
        changeDirWidgetOptions = [
          "--preview 'eza --tree --color=always {} | head -200'"
        ];
        historyWidgetOptions = [
          "--sort"
          "--exact"
          "--show-time"
        ];
      };
  };

  nixCats = {
    enable = true;
    packageNames = [ "neovim" ];
    luaPath = ./.;
    categoryDefinitions.replace =
      { pkgs, ... }: 
      {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            fd
            tree-sitter
          ];
        };
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            lze
          ];
        };
        optionalPlugins = {
          general = with pkgs.vimPlugins; [
            mini-nvim
            nvim-treesitter.withAllGrammars
          ];
        };
        sharedLibraries = {
          general = with pkgs; [ ];
        };
        environmentVariables = {};
      };
    packageDefinitions.replace = {
      neovim = {pkgs, name, ...}: {
        settings = {
          wrapRc = true;
          aliases = [ "haruvim" ];
        };
        categories = {
          general = true;
        };
      };
    };
  };
}
