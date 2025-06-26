vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "/mnt/c/Users/dmphalvormeen/Downloads/win32yank-x64/win32yank.exe -i --crlf",
    ["*"] = "/mnt/c/Users/dmphalvormeen/Downloads/win32yank-x64/win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "/mnt/c/Users/dmphalvormeen/Downloads/win32yank-x64/win32yank.exe -o --lf",
    ["*"] = "/mnt/c/Users/dmphalvormeen/Downloads/win32yank-x64/win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}

vim.g.autoformat = false
vim.g.disable_autoformat = true

vim.keymap.set("v", "p", "P", { silent = true })
vim.keymap.set("v", "P", "p", { silent = true })
