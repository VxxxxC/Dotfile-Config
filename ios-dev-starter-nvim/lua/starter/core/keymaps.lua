vim.g.mapleader = " "

P = function(f)
  vim.print(vim.inspect(f))
  return f
end

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }

-- disable updating register for x and c
keymap.set("n", "x", '"_x')
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')

-- splits management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

-- resize with arrows
keymap.set("n", "<A-Down>", "<cmd>resize -4<cr>", { desc = "Smaller horizontal split" })
keymap.set("n", "<A-Up>", "<cmd>resize +4<cr>", { desc = "Bigger horizontal split" })
keymap.set("n", "<A-Left>", "<cmd>vertical resize -4<cr>", { desc = "Smaller vertical split" })
keymap.set("n", "<A-Right>", "<cmd>vertical resize +4<cr>", { desc = "Bigger vertical split" })

-- tabs management
keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "[t", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "]t", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- buffers management
keymap.set("n", "<C-]>", "<cmd>bn<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<C-[>", "<cmd>bp<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "<leader>bn", "<cmd>new<CR>", { desc = "New buffer" })
keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>bx", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all buffers but this" })

-- copy & paste
keymap.set("x", "p", '"_dP')
keymap.set("x", "Y", "y$", { desc = "Yank to end of line" })
keymap.set("", "<leader>DD", '"_dd', { desc = "Delete without changing register" })

-- scrolling
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- indenting
keymap.set("v", "<A-h>", "<gv", { desc = "Indent left" })
keymap.set("v", "<A-l>", ">gv", { desc = "Indent right" })
keymap.set("n", "<A-h>", "<<", { desc = "Indent left" })
keymap.set("n", "<A-l>", ">>", { desc = "Indent right" })

-- jumping between issues
keymap.set("n", "<A-d>", "<cmd>silent cc | silent cn<cr>zz", { desc = "Jump to next issue" })
keymap.set("n", "<A-s>", "<cmd>silent cc | silent cp<cr>zz", { desc = "Jump to previous issue" })

-- other
keymap.set("n", "<leader>mm", "<cmd>messages<cr>", { desc = "Show messages" })
keymap.set("n", "}", '<cmd>execute "keepjumps norm! }"<cr>', { desc = "Next Paragraph" })
keymap.set("n", "{", '<cmd>execute "keepjumps norm! {"<cr>', { desc = "Previous Paragraph" })

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
keymap.set("n", "<leader><tab>", "<cmd>tabnew<CR>", { desc = "Open new tab" }, opts)
keymap.set("n", "<tab>", ":tabnext<Return>", { desc = "next tab" }, opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", { desc = "prev tab" }, opts)
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

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
