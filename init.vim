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

command Close  exec FindW("&pvw", 1) ? "pc" : FindW("&filetype", "netrw") ? "Lex" : FindL() ? "lcl" : FindQ() ? "ccl" : ""
command Files  let w = FindW("&filetype", "netrw") | exec w ? w .. "wincmd w": "Lex"
command Term   bot 10sp +term
command Unload exec winnr("$") > 1 ? "b#|bd#" : "bd"

command -nargs=+ Rg  exec "cexpr system('rg --vimgrep " .. <q-args> .. "')"
command -nargs=+ LRg exec "lexpr system('rg --vimgrep " .. <q-args> .. "')"

"aliases
Alias bu  Unload
Alias lrg LRg
Alias rg  Rg
Alias wd  w\|bd
Alias wu  w\|Unload

"highlights
highlight CursorLineNr cterm=NONE
highlight LineNr ctermfg=darkgray

highlight DiffAdd    ctermbg=darkgreen
highlight DiffChange ctermbg=darkyellow
highlight DiffDelete ctermbg=darkred
highlight DiffText   ctermbg=yellow

highlight SignColumn ctermbg=NONE

"maps
nmap <leader>\ :Files<cr>
nmap <leader>b :ls<cr>:b
nmap <leader>c <c-w>c
nmap <leader>d :bd<cr>
nmap <leader>h :noh<cr>
nmap <leader>l :lw<cr>
nmap <leader>q :cw<cr>
nmap <leader>t :Term<cr>
nmap <leader>u :Unload<cr>
vmap <silent> <leader>y :call Clip()<cr>

nmap <silent> <esc><esc> :Close<cr>
tmap <esc><esc> <C-\><C-n>

"maps (buffer)
nmap <silent> [B :bfirst<cr>
nmap <silent> [b :bprev<cr>
nmap <silent> ]b :bnext<cr>
nmap <silent> ]B :blast<cr>

"maps (location)
nmap <silent> [L :lfirst<cr>
nmap <silent> [l :lprev<cr>
nmap <silent> ]l :lnext<cr>
nmap <silent> ]L :llast<cr>

"maps (quickfix)
nmap <silent> [Q :cfirst<cr>
nmap <silent> [q :cprev<cr>
nmap <silent> ]q :cnext<cr>
nmap <silent> ]Q :clast<cr>

"maps (tab)
nmap <silent> [T :tabr<cr>
nmap <silent> [t :tabp<cr>
nmap <silent> ]t :tabn<cr>
nmap <silent> ]T :tabl<cr>

"maps (window)
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

nmap <m-=> <c-w>+
nmap <m--> <c-w>-
nmap <m-,> <c-w><
nmap <m-.> <c-w>>

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
set statuscolumn=%s%=%{v:relnum?v:relnum:v:lnum}╽
set tabstop=4

"options (location/quickfix)
augroup InitLQ
    autocmd!
    autocmd QuickFixCmdPost [Ll]* lw
    autocmd QuickFixCmdPost [^Ll]* cw
augroup end

"options (netrw)
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
