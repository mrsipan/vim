" .gvimrc - GUI vim configuration

" set guicursor+=a:blinkon0,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
set guicursor=n-v-c:block-Cursor/lCursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor/lCursor
set guicursor+=r-cr:hor20-Cursor/lCursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
set guicursor+=a:blinkon0

if has("gui_gtk2")
    set guifont=Droid\ Sans\ Mono\ Slashed\ 12
elseif has("gui_kde")
    set guifont=Droid\ Sans\ Mono\ Slashed\ 12
elseif has("gui_win32")
    set guifont=Lucida_Console:h10
elseif has("gui_mac") || has("gui_macvim")
    set guifont=Droid\ Sans\ Mono\ Slashed:h13
    set antialias
endif

set guioptions-=T
set lines=40

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Already set in .vimrc
" set noerrorbells

" according to doc, it needs to be set here again
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" Because the cursor gets invisible sometimes in gvim/linux
set nomousehide
