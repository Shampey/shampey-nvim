vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>h', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>l', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>j', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>k', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>H', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<leader>L', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<leader>J', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<leader>K', '<C-w>K', { desc = 'Move window to the upper' })

vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = '[B]uffer [D]estroy' })

vim.keymap.set('n', '<leader>bj', function()
  vim.ui.input({ prompt = 'Enter Buffer #: ' }, function(input)
    if input then vim.cmd(':LualineBuffersJump! ' .. input) end
  end)
end, { desc = '[B]uffer [J]ump' })
vim.keymap.set('n', '<leader>1', ':LualineBuffersJump! 1<CR>', { desc = 'Jump To Buffer 1' })
vim.keymap.set('n', '<leader>2', ':LualineBuffersJump! 2<CR>', { desc = 'Jump To Buffer 2' })
vim.keymap.set('n', '<leader>3', ':LualineBuffersJump! 3<CR>', { desc = 'Jump To Buffer 3' })
vim.keymap.set('n', '<leader>4', ':LualineBuffersJump! 4<CR>', { desc = 'Jump To Buffer 4' })
vim.keymap.set('n', '<leader>5', ':LualineBuffersJump! 5<CR>', { desc = 'Jump To Buffer 5' })
vim.keymap.set('n', '<leader>6', ':LualineBuffersJump! 6<CR>', { desc = 'Jump To Buffer 6' })
vim.keymap.set('n', '<leader>7', ':LualineBuffersJump! 7<CR>', { desc = 'Jump To Buffer 7' })
vim.keymap.set('n', '<leader>8', ':LualineBuffersJump! 8<CR>', { desc = 'Jump To Buffer 8' })
vim.keymap.set('n', '<leader>9', ':LualineBuffersJump! 9<CR>', { desc = 'Jump To Buffer 9' })
vim.keymap.set('n', '<leader>0', ':LualineBuffersJump! 10<CR>', { desc = 'Jump To Buffer 0' })
