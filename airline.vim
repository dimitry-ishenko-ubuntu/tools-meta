if !exists("g:airline_symbols")
    let g:airline_symbols = { }
endif

let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1
let g:airline_section_z = "%p%% ☰ %l/%L:%v"
let g:airline_section_z_term = "☰  %l/%L"
let g:airline_symbols.branch = "󰊢"
let g:airline_symbols.dirty = "*"
let g:airline_symbols.notexists = "-"
let g:airline_symbols.paste = ""
let g:airline_symbols.spell = ""
