" .vimrc - vim configuration file

" pathogen first
filetype off
call  pathogen#infect()

set autoindent
set background=dark
set backspace=indent,eol,start
set cinoptions=:0,l1,g0,t0,+.5s,(.5s,u0,U1,j1
set encoding=utf-8
set history=999
set incsearch
set listchars=tab:>-,trail:-
set modelines=5
set printoptions=paper:letter
set ruler
set showcmd
set showmatch
set showmode
set spelllang=en_us

function! CurrentBranchName()
python3 << EOF
try:
    import git
except ImportError:
    def branch_name():
        return 'check-gitpython'
else:
    import pathlib
    import vim

    def branch_name():
        cwd = pathlib.Path(vim.current.buffer.name).parent
        try:
            repo = git.Repo(cwd.as_posix(), search_parent_directories=True)
            name = repo.active_branch.name
            working_tree_dir, = repo.working_tree_dir.split('/')[-1:]
            return '{}/{}'.format(
                working_tree_dir,
                name[20:] if len(name) > 20 else name
                )
        except git.exc.InvalidGitRepositoryError:
            return 'invalid-git-error'
        except Exception:
            return 'general-git-error'
EOF

    return py3eval('branch_name()')

endfunction

set statusline=%<\%n:%F\ %m%r%y%=%-10.(%{CurrentBranchName()}\ L:\%l/%L\ C:\%c%V\ %P%)
set laststatus=2
" set tabpagemax=20
" split a window rightward and downward
set splitright
set splitbelow
" to ease moving across buffers
set hidden
" swap and backup files in one place
set directory^=~/.vim/tmp//
set backup
set backupdir^=~/.vim/tmp//
set autoread
set undodir=~/.vim/tmp//
set undofile

if &shell =~# 'xonsh$'
    set shell=sh
endif

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

let mapleader = "\<Space>"
let maplocalleader = "9"

" Mapping for spell checker
nmap <Leader>cs :up<CR>:!ispell -x %<CR>:e!<CR>

" Mapping to switch off search highlighting
nnoremap <silent> <Leader>/ :nohlsearch<CR>/<BS>

" Switch between windows
nmap <C-j> <C-w>j<C-w>_
nmap <C-k> <C-w>k<C-w>_
nmap <C-l> <C-w>l
nmap <C-h> <C-w>h

nmap <Leader>fw :w<CR>
" nmap <silent> <Leader>e :Ex<CR>
"nmap <silent> <C-p> :bp<CR>
"nmap <silent> <C-n> :bn<CR>
" nmap <silent> <Leader>q :bdel<CR>
nmap <silent> <Leader>fv :Vexplore!<CR>
" nmap <silent> <Leader>m :bmod<CR>

" don't use Ex mode, use Q for formatting, allows to use ZQ to quit
" without falling into ex mode by accident
" map Q gq
" or better just quit
nmap Q :q<CR>

" Make <Space> in normal mode go down half a page rather than
" left a character
nnoremap <Enter> <C-d>
nnoremap <BS> <C-u>
nnoremap <C-h> <C-u>
" ultisnips is overriden this:
vnoremap <Tab> <C-d>
autocmd VimEnter * vmap <Tab> <C-d>
vnoremap <BS> <C-u>

" CtrlP to open buffers and files
nnoremap <Leader>bb :CtrlPBuffer<CR>
nnoremap <Leader>bF :PrettyFormat<CR>
nnoremap <Leader>bD :bdel<CR>
nnoremap <Leader>bS :NewScratch<CR>
nnoremap <Leader>fh :CtrlP ~<CR>
nnoremap <Leader>ft :CtrlP ~/p<CR>
nnoremap <Leader>fd :CtrlP

nmap <A-r> :CtrlPClearCache<CR>

nnoremap <Leader>lp :lprevious<CR>
nnoremap <Leader>ln :lnext<CR>
nnoremap <Leader>lP :lfirst<CR>
nnoremap <Leader>lN :llast<CR>

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
    autocmd FileType java,javascript,perl,python,tcl,vim,groovy,julia,fish setl sw=4 sts=4 et
    autocmd FileType python let b:dispatch = 'pytest %'
    autocmd FileType go setlocal tabstop=3
    " Ada indent.
    autocmd FileType ada setlocal sw=3 sts=3 et
    " Expand tab in Scheme and Lisp to preserve alignment.
    autocmd FileType lisp,scheme setlocal et
    " Python doctest indent.
    autocmd FileType rst,cfg setlocal sw=4 sts=4 et tw=72
    " Yaml
    autocmd FileType yml,yaml,json setlocal tabstop=2 sw=2 sts=2 et
    " Shell scripts
    autocmd FileType cpp,sh,spec,clj,lua,pp,rs,Dockerfile setl tabstop=2 sw=2 et
    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute "normal g`\"" |
        \ endif

    " Remove trailing whitespaces on save
    autocmd BufWritePre *.py,*.rst,*.txt,*.clj,*.cljs,*.js,*.sh,*.rb,*.scala,*.groovy,Dockerfile :%s/\s\+$//e
    autocmd BufNewFile,BufRead Jenkinsfile set filetype=groovy

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
" autocmd Syntax clojure RainbowParenthesesLoadChevrons
autocmd BufEnter *.clj,*.cljs RainbowParenthesesToggle
autocmd BufLeave *.clj,*.cljs RainbowParenthesesToggle

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

let g:rbpt_types = [['(',')'],['\[','\]'],['{','}']]

let g:rbpt_max = 16
" let g:rbpt_loadcmd_toggle = 0

" toggle paste
set pastetoggle=<F2>

" sudo
cmap w!! w !sudo tee % >/dev/null

" syntastic for python
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_checker_args = '--ignore=E501,E225'
" let g:syntastic_python_flake8_exec = '~/opt/bin/flake8'

" syntastic for ruby
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_ruby_rubocop_exec = '/opt/chefdk/embedded/bin/rubocop'

let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': [],
            \ 'passive_filetypes': [] }

let g:syntastic_auto_loc_list = 1
let g:syntastic_error_symbol = '➔'
let g:syntastic_warning_symbol = '➔'
let g:syntastic_style_error_symbol = '◆'
let g:syntastic_style_warning_symbol = '◆'

nnoremap <Leader>fk :SyntasticCheck<CR>
nnoremap <Leader>fK :SyntasticReset<CR>

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
nnoremap gR :e! \| :redraw! \| :echom 'File reloaded'<CR>

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

if executable('rg')
    set grepprg=rg\ --no-heading\ --color=never
    let g:ctrlp_user_command = 'rg --no-heading --color=never --files'
    let g:gitgutter_grep_command = 'rg --no-heading --color=never'
elseif executable('pss')
    set grepprg=pss\ --noheading\ --nocolor
    let g:ctrlp_user_command = 'pss --ignore-dir="eggs,site-packages,_tmp,.cache" --noheading --nocolor -f'
    let g:gitgutter_grep_command = 'pss --noheading --nocolor'
endif

let g:gitgutter_sign_modified = '≠'
let g:gitgutter_sign_modified_removed = '±'

let g:gitgutter_enabled = 0
nnoremap gGg :GitGutterToggle<CR>
nnoremap gGb :Gblame<CR>

nnoremap <Leader>q @q

let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "mrsipan_ultisnips"]

let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
" let g:ctrlp_reuse_window = 'nofile\|help'

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
nnoremap <leader>fx :<C-U>RangerChooser<CR>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
elseif executable('pss')
    let g:ackprg = 'pss --nocolor'
endif

" if executable('opam')
"     let s:merlin = substitute(system('opam config var share'), '\n$', '', '''') . "/merlin"
"     execute "set rtp+=" . s:merlin . "/vim"
"     let g:syntastic_ocaml_checkers = ['merlin']
" endif

let g:elm_format_autosave = 1
let g:elm_setup_keybindings = 0

" let g:elm_syntastic_show_warnings = 1

autocmd bufwritepost *.js silent !standard --fix %
set autoread

" vim-qt workaround
set guifont=Droid\ Sans\ Mono\ Slashed\ 11

let g:terraform_fmt_on_save = 1

nnoremap <silent> <Leader>cp :cprev<CR>
nnoremap <silent> <Leader>cn :cnext<CR>
nnoremap <silent> <Leader>cN :clast<CR>
nnoremap <silent> <Leader>cP :cfirst<CR>
nnoremap <silent> <Leader>cc :cclose<CR>
nnoremap <silent> <Leader>co :copen<CR>

nnoremap <silent> <Leader>lp :lprev<CR>
nnoremap <silent> <Leader>ln :lnext<CR>
nnoremap <silent> <Leader>lP :lfirst<CR>
nnoremap <silent> <Leader>lN :llast<CR>
nnoremap <silent> <Leader>lc :lclose<CR>
nnoremap <silent> <Leader>lo :lopen<CR>

let g:sexp_mappings = {
    \ 'sexp_emit_head_element': '<LocalLeader>w',
    \ 'sexp_emit_tail_element': '<LocalLeader>e',
    \ 'sexp_capture_prev_element': '<LocalLeader>a',
    \ 'sexp_capture_next_element': '<LocalLeader>f',
    \ }

" nnoremap <Leader>oy "+y
" vnoremap <Leader>oy "+y

autocmd BufRead,BufNewFile *.confluencewiki set filetype=confluencewiki

set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
nnoremap <silent> gI :set invlist<CR>

" nnoremap <Leader>St :set filetype=rst<CR>
" nnoremap <Leader>Sy :set filetype=python<CR>
" nnoremap <Leader>Sc :set filetype=clojure<CR>

set clipboard+=unnamed

let g:yankring_map_dot = 0

" rst edits
nnoremap <silent> <Leader>bS :NewScratch<CR>
nnoremap <silent> <Leader>bV :w !editblogger -i -o \| lynx -stdin<CR><CR>

" Git
" nnoremap <silent> <Leader>fGb :Start git log -p -M --follow --stat -- %<CR>
nnoremap <silent> gGl :Start git log -p -M --stat \| diffr --colors refine-added:none:background:0x33,0x99,0x33:bold --colors added:none:background:0x33,0x55,0x33 --colors refine-removed:none:background:0x99,0x33,0x33:bold --colors removed:none:background:0x55,0x33,0x33 \| less -R -+F -C<CR>
nnoremap <silent> gGd :Start git diff \| diffr --colors refine-added:none:background:0x34,0x99,0x33:bold --colors added:none:background:0x33,0x55,0x33 --colors refine-removed:none:background:0x99,0x33,0x33:bold --colors removed:none:background:0x55,0x33,0x33  --line-numbers \| less -R -+F -C<CR>
nnoremap <silent> gGb :Start git blame % \| cut -d ' ' -f 2- \| ggrep -E --color=always '[0-9]+)' \| less -R -+F -C<CR>

nnoremap <Leader>dc :cd %:p:h<CR>:pwd<CR>
" nnoremap <Leader>bp :w !editblogger -b mrsipan -i<CR><CR>
nnoremap <Leader>bp :w !pandoc --from=org --to=rst \| sed 's/code:/colored-code:/g' \| editblogger -i -b salambria<CR><CR>

" To work with kitty
if !has('gui_running')
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    " let &t_ti = &t_ti . "\033]10;##dddddd\007\033]11;##424642\007"
    let &t_ti = &t_ti . "\033]10;##dddddd\007\033]11;##303030\007"
    let &t_te = &t_te . "\033]253\007\033]236\007"
endif


function! Pretty_format()
py3 << EOF
import vim
import time
import os
import sys
import pathlib
sys.path.append(
    pathlib.Path('~/.vim').expanduser().as_posix()
    )
import lib

vim.current.buffer[:] = lib.fmt(
    vim.current.buffer.options['filetype'],
    vim.current.buffer[:],
    )

    # for idx in range(1, len(buff) + 1):
    #     vim.current.buffer[0:idx] = buff[0:idx]
    #     vim.command('redraw!')
    #     time.sleep(.02)

EOF
endfunction

command! PrettyFormat call Pretty_format()

function! Insert_today()
py3 << EOF
import datetime
import pathlib
import sys
import vim
sys.path.append(
    pathlib.Path('~/.vim').expanduser().as_posix()
    )

win = vim.current.window
row_n, col_n = win.cursor
today = datetime.datetime.now().strftime('%A %B %d')

vim.current.buffer[row_n - 1:row_n - 1] = [today, '~' * len(today), '']
win.cursor = (win.cursor[0], 0)
vim.command('startinsert')

EOF
endfunction

command! InsertToday call Insert_today()
nnoremap <Leader>it :InsertToday<CR>

highlight DoneCheck ctermfg=194

function! Toggle_done()
py3 << EOF
import datetime
import pathlib
import sys
import vim
import re
sys.path.append(
    pathlib.Path('~/.vim').expanduser().as_posix()
    )

row_n, _ = vim.current.window.cursor
has_check = '✔' in vim.current.buffer[row_n - 1]

if not has_check:
    matcher = re.compile('^(\s*-)(.*)$').match(vim.current.buffer[row_n - 1])
    if matcher is None:
        print('Not formatted correctly')
    else:
        vim.current.buffer[row_n -1 ] = matcher.group(1) + ' ✔' + matcher.group(2)
else:
    matcher = re.compile('^(\s*-)(\s+✔\s+)(.*)$').match(vim.current.buffer[row_n - 1])
    if matcher is None:
        print('Not formatted correctly')
    else:
        vim.current.buffer[row_n -1] = matcher.group(1) + ' ' + matcher.group(3)

vim.command('match DoneCheck /✔.*$/')

EOF
endfunction

command! ToggleDone call Toggle_done()
nnoremap <Leader>id :ToggleDone<CR>
" match  DoneCheck /✔.*$/

command! -bar TurnOnScratchBuffer setlocal buflisted buftype=nofile bufhidden=hide noswapfile filetype=rst
command! -bar TurnOffScratchBuffer setlocal buftype= bufhidden= swapfile
command! -bar NewScratch new | TurnOnScratchBuffer

augroup scratch_buffers
    autocmd!
    autocmd StdinReadPre * TurnOnScratchBuffer
    autocmd VimEnter *
        \   if @% == '' && &buftype == ''
        \ |     TurnOnScratchBuffer
        \ | endif
    autocmd BufWritePost * ++nested
        \   if (empty(bufname()) || bufname() == '-stdin-') && &buftype == 'nofile'
        \ |     TurnOffScratchBuffer
        \ |     setlocal nomodified
        \ |     edit <afile>
        \ | endif
augroup END

set nofoldenable

let g:iced_enable_default_key_mappings = v:true

