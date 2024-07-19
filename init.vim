"commands/functions
function Alias(name, val)
    exec "cab <expr> " .. a:name .. " getcmdtype() == ':' && getcmdline() == '" .. a:name .. "' ? '" .. a:val .. "' : '" .. a:name .. "'"
endfunction
command -nargs=+ Alias call Alias(<f-args>)

function Clip()
    let [lb, cb] = getpos("'<")[1:2]
    let [le, ce] = getpos("'>")[1:2]
    let lines = getline(lb, le)
    if len(lines) > 0
        if visualmode() == "\<c-v>"
            let lines = map(lines, { _, v -> v[cb - 1 : ce - 1] })
        else
            let lines[ 0] = lines[ 0][cb - 1 : ]
            let lines[-1] = lines[-1][ : ce - 1]
        endif
    endif
    call system("xclip -in -selection clipboard", join(lines, "\n"))
endfunction

let FindL = { -> (filter(getwininfo(), { _, v -> v.loclist }) + [#{ winnr: 0 }])[0].winnr }
let FindQ = { -> (filter(getwininfo(), { _, v -> v.quickfix && !v.loclist }) + [#{ winnr: 0 }])[0].winnr }
let FindW = { var, val -> (filter(range(1, winnr("$")), { _, n -> getwinvar(n, var) == val }) + [0])[0] }

command Close exec FindW("&pvw", 1) ? "pc" : FindL() ? "lcl" : FindQ() ? "ccl" : ""
command Term  bot 10sp +term
command -bang Unload exec winnr("$") > 1 ? "b#|bd<bang>#" : "bd<bang>"

command -nargs=+ Rg  exec "cexpr system('rg --vimgrep " .. <q-args> .. "')"
command -nargs=+ LRg exec "lexpr system('rg --vimgrep " .. <q-args> .. "')"

"aliases
Alias bu  Unload
Alias lrg LRg
Alias rg  Rg
Alias wc  w\|wincmd\ c
Alias wd  w\|bd
Alias wu  w\|Unload

"highlights
highlight CursorLineNr cterm=NONE
highlight LineNr ctermfg=darkgray

highlight DiffAdd    ctermbg=darkgreen
highlight DiffChange ctermbg=darkblue
highlight DiffDelete ctermbg=darkred
highlight DiffText   ctermbg=darkyellow

highlight SignColumn ctermbg=NONE

"maps
nnoremap <leader>b :ls<cr>:b
nnoremap <leader>c <c-w>c
nnoremap <leader>d :bd<cr>
nnoremap <leader>D :bd!<cr>
nnoremap <leader>h :noh<cr>
nnoremap <leader>l :lw<cr>
nnoremap <leader>q :cw<cr>
nnoremap <leader>t :Term<cr>
nnoremap <leader>u :bu<cr>
nnoremap <leader>U :bu!<cr>
vnoremap <silent> <leader>y :call Clip()<cr>

nnoremap <silent> <esc><esc> :Close<cr>
tnoremap <esc><esc> <C-\><C-n>

nnoremap <silent> [{ ?{<cr>:noh<cr>
nnoremap <silent> [} ?}<cr>:noh<cr>
nnoremap <silent> ]{ /{<cr>:noh<cr>
nnoremap <silent> ]} /}<cr>:noh<cr>

"maps (buffer)
nnoremap <silent> [B :bfirst<cr>
nnoremap <silent> [b :bprev<cr>
nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> ]B :blast<cr>

"maps (local)
nnoremap <silent> [L :lfirst<cr>
nnoremap <silent> [l :lprev<cr>
nnoremap <silent> ]l :lnext<cr>
nnoremap <silent> ]L :llast<cr>

"maps (quickfix)
nnoremap <silent> [Q :cfirst<cr>
nnoremap <silent> [q :cprev<cr>
nnoremap <silent> ]q :cnext<cr>
nnoremap <silent> ]Q :clast<cr>

"maps (tab)
nnoremap <silent> [T :tabr<cr>
nnoremap <silent> [t :tabp<cr>
nnoremap <silent> ]t :tabn<cr>
nnoremap <silent> ]T :tabl<cr>

"maps (window)
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

nnoremap <m-=> <c-w>+
nnoremap <m--> <c-w>-
nnoremap <m-,> <c-w><
nnoremap <m-.> <c-w>>

"options
set cursorline
set cursorlineopt=number
set expandtab
set fillchars=eob:·
set hidden
set number
set numberwidth=3
set relativenumber
set shiftwidth=4
set signcolumn=yes
set smartindent
set splitright
set tabstop=4

"options (location/quickfix)
augroup InitLQ
    autocmd!
    autocmd QuickFixCmdPost [Ll]* lw
    autocmd QuickFixCmdPost [^Ll]* cw
augroup end

"options (term)
autocmd TermOpen,BufEnter * if &buftype == "terminal" | startinsert | endif
