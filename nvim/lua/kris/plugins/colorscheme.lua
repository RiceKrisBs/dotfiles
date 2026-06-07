-- options:
-- kanagawa
-- rose-pine
-- cyberdream
-- bamboo

local default_colorscheme = "rose-pine"

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      if default_colorscheme == "kanagawa" then
        vim.cmd.colorscheme("kanagawa")
      end
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon", -- auto, main, moon, or dawn
      dark_variant = "moon", -- main, moon, or dawn
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      if default_colorscheme == "rose-pine" then
        vim.cmd.colorscheme("rose-pine")
      end
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "default",
      italic_comments = true,
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      if default_colorscheme == "cyberdream" then
        vim.cmd.colorscheme("cyberdream")
      end
    end,
  },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "vulgaris",
      code_style = {
        comments = { italic = true },
        parameters = { italic = true },
      },
    },
    config = function(_, opts)
      require("bamboo").setup(opts)
      if default_colorscheme == "bamboo" then
        vim.cmd.colorscheme("bamboo")
      end
    end,
  },
}
