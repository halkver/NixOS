{ config, pkgs, ... }: {
  programs.neovim = {
    extraConfig = ''
      # This is ADDED to the globals from common.nix
      clipboard = {
        name = "WslClipboard";
        copy = {
          ["+"] = "clip.exe";
          ["*"] = "clip.exe";
        };
        paste = {
          ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))';
          ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))';
        };
        cache_enabled = 1;
      };};
   '';
  };
}
