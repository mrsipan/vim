" .vimrc - vim configuration file

" pathogen first
filetype off
call  pathogen#infect()

set autoindent
set background=dark
set backspace=indent,eol,start
set cinoptions=:0,l1,g0,t0,+.5s,(.5s,u0,U1,j1
set encoding=utf-8
set history=50
set incsearch
set listchars=tab:>-,trail:-
set modelines=5
set printoptions=paper:letter
set ruler
set showcmd
set showmatch
set showmode
set spelllang=en_us
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(L:\ %l/%L,\ C:\ %c%V\ (%P)%)
set laststatus=2
" set tabpagemax=20
" split a window rightward and downward
set splitright
set splitbelow
" to ease moving across buffers
set hidden
" swap and backup files in one place
set directory^=~/.vim/tmp//
set backupdir^=~/.vim/tmp//

" Use syntax highlighting when terminal allows it
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Appearance
if &background == "dark"
    if &t_Co == 256 || has("gui_running")
        colorscheme sipan
    else
        colorscheme simple8
    endif
endif

" Treat .h files as .c (not .cpp)
let c_syntax_for_h = 1
" OpenBSD has sh -> ksh and Linux has sh -> bash
let is_kornshell = 1

" leader ',' and localleader '\'
let mapleader = ","
" Mapping for spell checker
nmap <Leader>s :up<CR>:!ispell -x %<CR>:e!<CR>
" Mapping to switch off search highlighting
nmap <silent> <Leader>h :nohlsearch<CR>
nmap <silent> <Leader>, :nohlsearch<CR>

" Switch between windows
nmap <C-j> <C-w>j<C-w>_
nmap <C-k> <C-w>k<C-w>_
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h

nmap <Leader>w :w<CR>
" nmap <silent> <Leader>e :Ex<CR>
"nmap <silent> <C-p> :bp<CR>
"nmap <silent> <C-n> :bn<CR>
" nmap <silent> <Leader>q :bdel<CR>
nmap <silent> <Leader>e :Vexplore!<CR>
" nmap <silent> <Leader>m :bmod<CR>

" don't use Ex mode, use Q for formatting, allows to use ZQ to quit
" without falling into ex mode by accident
" map Q gq
" or better just quit
nmap Q :q<CR>

" Make <Space> in normal mode go down half a page rather than
" left a character
noremap <Space> <C-d>
noremap <BS> <C-u>

" CtrlP to open buffers and files
nmap <Leader>b :CtrlPBuffer<CR>
"nmap <Leader>f :CtrlP<CR>
let g:ctrlp_map = '<Leader>f'
let g:ctrlp_cmd = 'CtrlP'

"set wildignore+=*/tmp/*,*.so,*.swp,*.zip

let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn)$|develop-eggs$|eggs$|Library$',
  \ 'file': '\v\.(exe|so|dll|iso|tar\.gz|pdf|ps|jpeg|jpg|png|rpm|mp3|epub|chm|tmp|pyo|pyc|elc|old|dmg|xcf)$',
  \ }

" Set minimum window height to 0
set winminheight=0
" And minimum width
set winminwidth=0

" convenient way to access buffers with tab
set wildmenu wildmode=list:longest,full

" Help other people with your file if layout is not default
iabbrev MODELINE vi:set sw=4 ts=4 sts=0 noet:<Esc>

" File type dependent options
if has("autocmd")
    " Enable file type detection, plugins, and indentation rules.
    filetype plugin indent on
    " In text files, always limit the width of text to 72 characters.
    autocmd FileType text,nroff setlocal tw=72
    " DocBook, HTML, TeX, SGML, and XML indent and text width.
    autocmd FileType tex,docbk,html,sgml,xhtml,xml setl sw=2 sts=2 et tw=72
    " Get rid of the annoying reverse for HTML italic.
    autocmd FileType html,xhtml hi htmlItalic term=underline cterm=underline
    " Java, JavaScript, Perl, Python and Tcl indent.
    autocmd FileType java,javascript,perl,python,tcl,vim,go setl sw=4 sts=4 et
    " Ada indent.
    autocmd FileType ada setlocal sw=3 sts=3 et
    " Expand tab in Scheme and Lisp to preserve alignment.
    autocmd FileType lisp,scheme setlocal et
    " Python doctest indent.
    autocmd FileType rst,cfg setlocal sw=4 sts=4 et tw=72
    " Shell scripts
    autocmd FileType cpp,sh,spec,clj,lua,pp,rs setl tabstop=2 sw=2 et
    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal g`\"" |
        \ endif
    " Remove trailing whitespaces on save
    autocmd BufWritePre *.py :%s/\s\+$//e
    autocmd BufWritePre *.clj :%s/\s\+$//e
    autocmd BufWritePre *.js :%s/\s\+$//e
    autocmd BufWritePre *.sh :%s/\s\+$//e

endif

" Get rid of screen flash and beep
set noerrorbells
set visualbell t_vb=

" Ignore case in a pattern
set ignorecase
set smartcase

" ctrl-u in insert mode deletes a lot. use ctrl-g u to first break undo
" so that you can undu ctrl-u after inserting a new line
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

if has('mouse')
    set mouse=a
endif

" Convenient command to see the diff between the current buffer and
" the file it has loaded from, thus the change you made. Only define it
" when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" do not set cursor line in netrw
let g:netrw_cursor = 0

" Settings for clojure
let g:clojure_align_multiline_strings = 1

autocmd Syntax clojure RainbowParenthesesLoadRound
autocmd BufEnter *.clj RainbowParenthesesToggle
autocmd BufLeave *.clj RainbowParenthesesToggle

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
" let g:rbpt_loadcmd_toggle = 0

" toggle paste
set pastetoggle=<F2>

" sudo
cmap w!! w !sudo tee % >/dev/null

" syntastic for python
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_checker_args='--ignore=E501,E225'

let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': [],
            \ 'passive_filetypes': [] }

let g:syntastic_auto_loc_list = 1

" completion in ex mode
if exists("&wildignorecase")
    set wildignorecase
endif
if exists("&fileignorecase")
    set fileignorecase
endif


" store yankring history file in tmp
let g:yankring_history_dir = '$HOME/.vim/tmp'
