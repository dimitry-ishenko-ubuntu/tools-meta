-- Basic options
vim.opt.completeopt = {"menu", "menuone", "noinsert"}
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.expandtab = true
vim.opt.fillchars = {eob = "·"}
vim.opt.hidden = true
vim.opt.keywordprg = ":help"
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.splitright = true
vim.opt.tabstop = 4

-- Functions
function create_alias(alias, cmd)
    vim.cmd(string.format(
        "cnoreabbrev <expr> %s getcmdtype() == ':' && getcmdline() ==# '%s' ? '%s' : '%s'",
        alias, alias, cmd, alias
    ))
end

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {noremap = true})
end

local function toggle_loclist()
    local loc = vim.fn.getloclist(0, {winid = 0, size = 0})
    vim.cmd((loc.winid > 0) and "lclose" or (loc.size > 0) and "lopen" or "echo 'No locations'")
end

local function toggle_quickfix()
    local qf = vim.fn.getqflist({winid = 0})
    vim.cmd((qf.winid > 0) and "cclose" or "copen")
end

-- Commands & aliases
create_alias("wc", "w\\|wincmd c")
create_alias("wd", "w\\|bd")

-- Basic maps
map("n", "<leader>b", "<cmd>ls<cr>:b")
map("n", "<leader>c", "<c-w>c")
map("n", "<leader>d", "<cmd>bd<cr>")
map("n", "<leader>D", "<cmd>bd!<cr>")
map("n", "<leader>h", "<cmd>noh<cr>")
map("n", "<leader>l", toggle_loclist)
map("n", "<leader>q", toggle_quickfix)

map("n", "zr", "<cmd>spellr<cr>")
map("n", "<leader>z", "<cmd>setlocal spell! spell?<cr>")

map("n", "<m-=>", "<c-w>+")
map("n", "<m-->", "<c-w>-")
map("n", "<m-,>", "<c-w><")
map("n", "<m-.>", "<c-w>>")

-- terminal
map("t", "<esc><esc>", "<c-\\><c-n>")

vim.api.nvim_create_autocmd({"TermOpen", "BufEnter"}, {
    pattern = "*",
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end
})

-- Diagnostic
vim.diagnostic.config({
    signs = { text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN ] = "",
        [vim.diagnostic.severity.HINT ] = "",
        [vim.diagnostic.severity.INFO ] = "",
    },
    severity_sort = true,
}})

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local bufmap = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, {buffer = event.buf})
        end
        bufmap("n", "gd",  "<cmd>lua vim.lsp.buf.definition()<cr>")
        bufmap("n", "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
        bufmap("n", "grd", "<cmd>lua vim.lsp.buf.declaration()<cr>")
        bufmap({"n", "x"}, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>")
    end
})
