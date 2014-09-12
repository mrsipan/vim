" ~/.vim/filetype.vim - personal file type definitions

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
" I write doctest (reStructuredText) files for Python/Zope all the time.
" Hence, the treatment of text files has been changed.
"autocmd! BufNewFile,BufRead *.txt setfiletype text
autocmd! BufNewFile,BufRead *.txt setfiletype rst
autocmd! BufNewFile,BufRead *.tmac,*.ref,*.refer,*.pic setfiletype nroff
autocmd! BufNewFile,BufRead ~/.mutt/* setfiletype muttrc
autocmd! BufNewFile,BufRead ksh.kshrc,.shrc,sh.shrc call SetFileTypeSH("ksh")
autocmd! BufNewFile,BufRead *.ss setfiletype scheme
autocmd! BufNewFile,BufRead pf.conf* setfiletype pf
autocmd! BufNewFile,BufRead *.mmp setfiletype mp
autocmd! BufNewFile,BufRead *.x68 setfiletype asm | set syntax=asm68k
autocmd! BufNewFile,BufRead patch-* setfiletype diff
autocmd! BufNewFile,BufRead *.zcml setfiletype xml
autocmd! BufNewFile,BufRead *.sh set tabstop=2|set expandtab|set shiftwidth=2
autocmd! BufNewFile,bufRead *.ebuild set tabstop=2|set shiftwidth=2|set expandtab
autocmd! BufNewFile,bufRead *.vim set tabstop=4|set shiftwidth=4|set expandtab
autocmd! BufNewFile,bufRead *.rs set tabstop=2|set shiftwidth=2|set expandtab
autocmd! BufNewFile,bufRead *.ml,*.mli set tabstop=2|set shiftwidth=2|set expandtab
autocmd! BufNewFile,bufRead *.clj,*.cljs setfiletype clojure
autocmd! BufNewFile,bufRead *.vala set tabstop=2|set shiftwidth=2|set expandtab
augroup END

