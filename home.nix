{
  inputs,
  lib,
  pkgs,
  ...
}:
{
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
      settings = { line-length = 120; };
    };

    nvf = {
      enable = true;
      settings.vim = {
        vimAlias = true;
        options = {
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
        };
        keymaps = [
          {
            key = "p";
            mode = "v";
            silent = true;
            action = "P";
          }
          {
            key = "P";
            mode = "v";
            silent = true;
            action = "p";
          }
        ];
        clipboard = {
          enable = true;
          providers.xclip.enable = true;
          registers = "unnamedplus";
        };
        autocmds = [
          {
            enable = true;
            event = [ "CursorHold" ];
            command = "lua vim.diagnostic.open_float(nil, {focus=false})";
            pattern = [ "*" ];
          }
        ];
        formatter.conform-nvim.enable = true;
        lsp.enable = true;
        languages = {
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          python = {
            enable = true;
            format = {
              enable = true;
              type = "ruff";
            };
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };
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
}
