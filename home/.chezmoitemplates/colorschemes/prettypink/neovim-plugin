return {
  {
    'catppuccin/nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
    config = function()
      require('catppuccin').setup {
        flavour = "frappe", 
        integrations = {
          cmp = true,
          dap = true,
          gitsigns = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          neotree = true,
          telescope = {
            enabled = true,
          },
          treesitter = true,
          which_key = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
              ok = { "italic" },
          },
          underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
              ok = { "underline" },
          },
          inlay_hints = {
              background = true,
          },
        },
        term_colors = true,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
