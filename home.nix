{ pkgs, ... }:
l{
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
            enable = false;
            event = [ "CursorHold" ];
            command = "lua vim.diagnostic.open_float(nil, {focus=false})";
            pattern = [ "*" ];
          }
        ];
        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          python.enable = true;
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

    fzf = {
      enable = true;
      enableFishIntegration = false;
      defaultOptions = [
        "--layout=reverse"
        "--height=40%"
      ];
      fileWidgetOptions = [
        "--preview 'if test -d {}; eza --tree --color=always --icons --git --level=2 {} | head -n 50; else; bat --color=always --style=numbers {}; end'"
      ];
    };
  };
}
