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
      noto-fonts-cjk-sans
      python3
      postgresql
      fd
      openssl
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
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';
      shellAliases = {
        rb = "sudo nixos-rebuild switch --flake ~/NixOS/.";
        nixconf = "vim ~/NixOS";
        dev = "nix develop ~/NixOS/.#pyshell -c $SHELL";
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
        fileWidgetCommand = "fd --type f --strip-cwd-prefix";
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

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
