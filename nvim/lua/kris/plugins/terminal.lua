return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Floating terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
    },
    opts = {
      direction = "horizontal",
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        end
        return math.floor(vim.o.columns * 0.4)
      end,
      open_mapping = [[<C-\>]],
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = false,
      shade_terminals = false,
      float_opts = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local claude = Terminal:new({
        cmd = "claude",
        count = 9,
        direction = "vertical",
        hidden = true,
        close_on_exit = false,
      })

      vim.keymap.set("n", "<leader>tc", function()
        if vim.fn.executable("claude") == 0 then
          vim.notify("The claude CLI was not found on PATH.", vim.log.levels.WARN)
          return
        end

        claude:toggle()
      end, { desc = "Claude terminal" })

      vim.api.nvim_create_user_command("Claude", function()
        claude:toggle()
      end, { desc = "Toggle Claude terminal" })

      vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("kris.terminal", { clear = true }),
        pattern = "term://*",
        callback = function(event)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("t", lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("<Esc><Esc>", [[<C-\><C-n>]], "Leave terminal mode")
        end,
      })
    end,
  },
}
