{inputs, ...}: let
  utils = inputs.nixCats.utils;
in {
  nixCats = {
    enable = true;
    addOverlays = [ (utils.standardPluginOverlay inputs) ];
    packageNames = [ "neovim" ];
    luaPath = ./.;
    categoryDefinitions.replace =
      { pkgs, ... }: 
      {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            tree-sitter
            ruff
            basedpyright
            stylua
            lua-language-server
            nixd
            alejandra
            terraform-ls
            biome
          ];
        };
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            lze
            lzextras
            snacks-nvim
            onedark-nvim
          ];
        };
        optionalPlugins = {
          general = with pkgs.vimPlugins; [
            mini-nvim
            nvim-lspconfig
            conform-nvim
            blink-cmp
            nvim-lint
            lualine-nvim
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
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "vim" ];

          hosts.python3.enable = true;
        };
        categories = {
          general = true;
        };
      };
    };
  };
}
