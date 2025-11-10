local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
-- keymap.set("n", "x", '"_x')
-- keymap.set("n", "<Leader>p", '"0p')
-- keymap.set("n", "<Leader>P", '"0P')
-- keymap.set("v", "<Leader>p", '"0p')
-- keymap.set("n", "<Leader>c", '"_c')
-- keymap.set("n", "<Leader>C", '"_C')
-- keymap.set("v", "<Leader>c", '"_c')
-- keymap.set("v", "<Leader>C", '"_C')
-- keymap.set("n", "<Leader>d", '"_d')
-- keymap.set("n", "<Leader>D", '"_D')
-- keymap.set("v", "<Leader>d", '"_d')
-- keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
-- keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
-- keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
-- keymap.set("n", "<leader><tab>", ":tabedit<CR>") NOTE: set in which-key config
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- jumping between issues
keymap.set("n", "<A-d>", "<cmd>silent cc | silent cn<cr>zz", { desc = "Jump to next issue" })
keymap.set("n", "<A-s>", "<cmd>silent cc | silent cp<cr>zz", { desc = "Jump to previous issue" })

-- other
keymap.set("n", "}", '<cmd>execute "keepjumps norm! }"<cr>', { desc = "Next Paragraph" })
keymap.set("n", "{", '<cmd>execute "keepjumps norm! {"<cr>', { desc = "Previous Paragraph" })
keymap.set("n", "<s-h>", "^", opts)
keymap.set("n", "<s-l>", "$", opts)

-- Floating Terminal
keymap.set({ "n", "t" }, "<leader>T", function()
  require("float_term").float_term("fish", { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Toggle Floating Terminal" })

-- Change Replace keymap
keymap.set("n", "r", "R")

-- Change R to global search and replace keymap
keymap.set("n", "R", ":%s/")

-- Jump into hyper tag in vim doc
-- keymap.set("n", "<CR>", "<C-]>", opts)

-- bordered style hover floating window for Lsp Doc NOTE: use LspSaga hover doc
keymap.set(
  "n",
  "K",
  "<CMD>Lspsaga hover_doc<CR>",
  --[[ function()  vim.lsp.buf.hover({ border = "single", width = 60 })end, ]]
  opts
)

-- ESC
keymap.set("n", "<ESC>", ":noh<CR>")
