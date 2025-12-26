vim.pack.add({
    {src = "https://github.com/blazkowolf/gruber-darker.nvim"},
    {src = "https://github.com/nvim-lualine/lualine.nvim"},
    {src = "https://github.com/stevearc/oil.nvim"},
    {src = "https://github.com/ej-shafran/compile-mode.nvim"},
    {src = "https://github.com/nvim-lua/plenary.nvim"},
    {src = "https://github.com/mason-org/mason.nvim"},
    {src = "https://github.com/chikko80/error-lens.nvim"},
    {src = "https://github.com/hrsh7th/nvim-cmp"},
    {src = "https://github.com/hrsh7th/cmp-nvim-lsp"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter"},
    {src = "https://github.com/Airbus5717/c3.vim"}
})
vim.cmd [[color gruber-darker]]
vim.g.mapleader = " "

vim.api.nvim_set_option("clipboard", "unnamed")

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8

vim.opt.fillchars = {eob = ' '}

require('lualine').setup()

require("oil").setup()
vim.keymap.set("n", "<Leader>k", "<CMD>Oil<CR>", { desc = "Open parent directory" })


vim.g.compile_mode = {}
local last_compile_command = nil

-- Function to run the compile command
function CompileCommand()
  if last_compile_command then
    -- Ask if user wants to run the last compile command
    vim.ui.input({
      prompt = "Run the last compilation command (" .. last_compile_command .. ")? (y/n): ",
      default = "y",
    }, function(answer)
      if answer == "y" or answer == "Y" then
        -- Run the last compile command
        vim.cmd(last_compile_command)
      else
        -- Prompt for a new compile command
        vim.cmd(":Compile")
      end
    end)
  else
    -- No previous command, run :Compile normally
    vim.cmd(":Compile")
  end
end

vim.api.nvim_set_keymap('n', '<leader>c', ':lua CompileCommand()<CR>', { noremap = true, silent = true })

require("mason").setup()

local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()


local cmp = require("cmp")


cmp.setup({
  completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

vim.lsp.config("clangd", {
  capabilities = capabilities,
})
vim.lsp.config("c3_lsp", {
  capabilities = capabilities,
})
vim.lsp.config("rust-analyzer", {
  capabilities = capabilities,
})

vim.lsp.enable(lsp_configs)
require("error-lens").setup(client, {})

