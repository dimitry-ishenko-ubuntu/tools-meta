"basic
set expandtab
set fillchars=eob:·
set hidden
set shiftwidth=4
set smartindent
set tabstop=4

let FindL = { -> (filter(getwininfo(), { _, v -> v.loclist }) + [#{ winnr: 0 }])[0].winnr }
let FindQ = { -> (filter(getwininfo(), { _, v -> v.quickfix && !v.loclist }) + [#{ winnr: 0 }])[0].winnr }
let FindW = { var, val -> (filter(range(1, winnr("$")), { _, n -> getwinvar(n, var) == val }) + [0])[0] }

function Alias(name, val)
    exec "cabbrev <expr> " .. a:name .. " getcmdtype() == ':' && getcmdline() == '" .. a:name .. "' ? '" .. a:val .. "' : '" .. a:name .. "'"
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

command Close exec FindW("&pvw", 1) ? "pc" : FindW("&filetype", "netrw") ? "Lex" : FindL() ? "lcl" : FindQ() ? "ccl" : ""

command Files let w = FindW("&filetype", "netrw") | exec w ? w .. "wincmd w": "Lex"

command Term bot 10sp +term

command Unload exec winnr("$") > 1 ? "b#<bar>bd#" : "bd"
Alias bu Unload

Alias wd w\|bd
Alias wu w\|Unload

"location/quickfix
augroup InitLQ
    autocmd!
    autocmd QuickFixCmdPost [Ll]* lw
    autocmd QuickFixCmdPost [^Ll]* cw
augroup end

"netrw
let g:netrw_fast_browse = 0
let g:netrw_list_hide = ".*\.swp$"
let g:netrw_liststyle = 3
let g:netrw_sort_sequence = "[\/]$"
let g:netrw_sort_options = "i"
let g:netrw_winsize = 30

augroup InitNetrw
    autocmd!
    autocmd FileType netrw nmap <buffer> <tab> mf
    autocmd FileType netrw nmap <buffer> <s-tab> mF
    autocmd FileType netrw nmap <buffer> <m-tab> mu
    autocmd FileType netrw setl bufhidden=wipe
augroup end

"search
command -nargs=+ Rg  exec "cexpr system('rg --vimgrep " .. <q-args> .. "')"
command -nargs=+ LRg exec "lexpr system('rg --vimgrep " .. <q-args> .. "')"

Alias rg Rg
Alias lrg LRg

"maps
nmap <leader>\ :Files<cr>
nmap <leader>b :ls<cr>b
nmap <leader>c <c-w>c
nmap <leader>d :bd<cr>
nmap <leader>h :noh<cr>
nmap <leader>l :lw<cr>
nmap <leader>q :cw<cr>
nmap <leader>u :Unload<cr>
vmap <silent> <leader>y :call Clip()<cr>

nmap <silent> <esc><esc> :Close<cr>
tmap <esc><esc> <C-\><C-n>

"buffers
nmap <silent> [B :bfirst<cr>
nmap <silent> [b :bprev<cr>
nmap <silent> ]b :bnext<cr>
nmap <silent> ]B :blast<cr>

"location
nmap <silent> [L :lfirst<cr>
nmap <silent> [l :lprev<cr>
nmap <silent> ]l :lnext<cr>
nmap <silent> ]L :llast<cr>

"quickfix
nmap <silent> [Q :cfirst<cr>
nmap <silent> [q :cprev<cr>
nmap <silent> ]q :cnext<cr>
nmap <silent> ]Q :clast<cr>

"tabs
nmap <silent> [T :tabr<cr>
nmap <silent> [t :tabp<cr>
nmap <silent> ]t :tabn<cr>
nmap <silent> ]T :tabl<cr>

"windows
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

nmap <m-=> <c-w>+
nmap <m--> <c-w>-
nmap <m-,> <c-w><
nmap <m-.> <c-w>>
