return {
  {
    'catppuccin/nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
