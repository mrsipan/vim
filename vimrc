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
set statusline=%<\%n:%f\ %m%r%y%=%-10.(%{fugitive#statusline()}\ L:\%l/%L\ C:\%c%V\ %P%)
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
set autoread

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
let mapleader = "\<Space>"
" Mapping for spell checker
nmap <Leader>cs :up<CR>:!ispell -x %<CR>:e!<CR>
" Mapping to switch off search highlighting
nmap <silent> <Leader>h :nohlsearch<CR>

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
nnoremap <Tab> <C-d>
nnoremap <BS> <C-u>
" ultisnips is overriden this:
vnoremap <Tab> <C-d>
autocmd VimEnter * vmap <Tab> <C-d>
vnoremap <BS> <C-u>

" CtrlP to open buffers and files
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>fh :CtrlP ~<CR>
nnoremap <Leader>ft :CtrlP ~/p<CR>
nnoremap <Leader>fe :CtrlP /etc<CR>
nnoremap <Leader>fl :CtrlP /var/log<CR>
nnoremap <Leader>fd :CtrlP

nmap <A-r> :CtrlPClearCache<CR>


let g:ctrlp_map = '<Leader>ff'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 1

" set wildignore=*.so,*.swp,*.zip

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
    autocmd FileType java,javascript,perl,python,tcl,vim,go,groovy setl sw=4 sts=4 et
    " Ada indent.
    autocmd FileType ada setlocal sw=3 sts=3 et
    " Expand tab in Scheme and Lisp to preserve alignment.
    autocmd FileType lisp,scheme setlocal et
    " Python doctest indent.
    autocmd FileType rst,cfg setlocal sw=4 sts=4 et tw=72
    " Yaml
    autocmd FileType yml,yaml setlocal sw=2 sts=2 et
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
    autocmd BufWritePre *.rb :%s/\s\+$//e
    autocmd BufWritePre *.scala :%s/\s\+$//e
    autocmd BufWritePre *.groovy :%s/\s\+$//e

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
autocmd Syntax clojure RainbowParenthesesLoadSquare
autocmd Syntax clojure RainbowParenthesesLoadBraces
autocmd Syntax clojure RainbowParenthesesLoadChevrons
autocmd BufEnter *.clj RainbowParenthesesToggle
autocmd BufLeave *.clj RainbowParenthesesToggle

let g:rbpt_colorpairs = [
     \ ['102', '#8c8c8c'],
     \ ['110', '#93a8c6'],
     \ ['143', '#b0b1a3'],
     \ ['108', '#97b098'],
     \ ['146', '#aebed8'],
     \ ['145', '#b0b0b3'],
     \ ['110', '#90a890'],
     \ ['148', '#a2b6da'],
     \ ['145', '#9cb6ad']
     \ ]

let g:rbpt_max = 16
" let g:rbpt_loadcmd_toggle = 0

" toggle paste
set pastetoggle=<F2>

" sudo
cmap w!! w !sudo tee % >/dev/null

" syntastic for python
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_checker_args = '--ignore=E501,E225'
" let g:syntastic_python_flake8_exec = '~/opt/bin/flake8'

" " syntastic for ruby
" let g:syntastic_ruby_checkers = ['rubocop']
" let g:syntastic_ruby_rubocop_exec = '/opt/chefdk/bin/rubocop'

" let g:syntastic_mode_map = { 'mode': 'passive',
"             \ 'active_filetypes': [],
"             \ 'passive_filetypes': [] }

" let g:syntastic_auto_loc_list = 1
" let g:syntastic_error_symbol = '➔'
" let g:syntastic_warning_symbol = '➔'
" let g:syntastic_style_error_symbol = '◆'
" let g:syntastic_style_warning_symbol = '◆'

" nnoremap <Leader>cp :SyntasticCheck<CR>
" nnoremap <Leader>cP :SyntasticReset<CR>

" completion in ex mode
if exists("&wildignorecase")
    set wildignorecase
endif
if exists("&fileignorecase")
    set fileignorecase
endif


" store yankring history file in tmp
let g:yankring_history_dir = '$HOME/.vim/tmp'

" Reload file
nmap gR :e!<CR>

" " paste and go to end
" vnoremap <silent> y y`]
" vnoremap <silent> p p`]
" nnoremap <silent> p p`]

" highlight last insert
nnoremap gV `[v`]

highlight ExtraWhitespace ctermbg=188 guibg=#d2d2d2
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" paredit enabled manually
let g:paredit_mode = 0
let g:paredit_electric_return = 1

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag -l --nocolor --hidden -g "" %s'
    let g:gitgutter_grep_command = 'ag --nocolor'
elseif executable('pss')
    set grepprg=pss\ --nocolor
    let g:ctrlp_user_command = 'pss --ignore-dir="eggs,site-packages,_tmp,.cache" -f %s'
endif

let g:gitgutter_sign_modified = '≠'
let g:gitgutter_sign_modified_removed = '±'

let g:gitgutter_enabled = 0
nmap <leader>gu :GitGutterToggle<CR>

nnoremap <Leader>q @q

let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "mrsipan_ultisnips"]

let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" From ranger's examples dir
function! RangeChooser()
    let temp = tempname()

    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif

    if !filereadable(temp)
        redraw!
        return
    endif

    let names = readfile(temp)

    if empty(names)
        redraw!
        return
    endif

    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])

    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!

endfunction

command! -bar RangerChooser call RangeChooser()
nnoremap <leader>fo :<C-U>RangerChooser<CR>

" Create a scratch buffer
nnoremap <Leader>fh  :vnew<cr>:setlocal buftype=nofile bufhidden=wipe nobuflisted<cr>
:command! -nargs=1 KeepScratch setlocal buftype= | file <args> | w

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
elseif executable('pss')
    let g:ackprg = 'pss --nocolor'
endif

if executable('opam')
    let s:merlin = substitute(system('opam config var share'), '\n$', '', '''') . "/merlin"
    execute "set rtp+=" . s:merlin . "/vim"
    let g:syntastic_ocaml_checkers = ['merlin']
endif

let g:elm_format_autosave = 1
let g:elm_setup_keybindings = 0

" let g:elm_syntastic_show_warnings = 1

autocmd bufwritepost *.js silent !standard --fix %
set autoread
