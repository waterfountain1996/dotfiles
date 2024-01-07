-- Shift text in visual mode
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

-- Shift current selection up or down with indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy text until EOL
vim.keymap.set("n", "Y", "yg_", { noremap = true })

-- Directory tree
vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true })

-- Buffer controls
vim.keymap.set("n", "<C-k>", ":bn<CR>", { noremap = true })
vim.keymap.set("n", "<C-j>", ":bp<CR>", { noremap = true })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { noremap = true })
