" ~/.vim/filetype.vim - personal file type definitions

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
" I write doctest (reStructuredText) files for Python/Zope all the time.
" Hence, the treatment of text files has been changed.
"autocmd! BufNewFile,BufRead *.txt setfiletype text
autocmd! BufNewFile,BufRead *.txt setfiletype rst
autocmd! BufNewFile,BufRead .xonshrc setfiletype python
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
autocmd! BufNewFile,bufRead *.rs set tabstop=4|set shiftwidth=4|set expandtab
autocmd! BufNewFile,bufRead *.ml,*.mli,*.rb,*Rakefile set tabstop=2|set shiftwidth=2|set expandtab
autocmd! BufNewFile,bufRead *.clj,*.cljs,*.gk,*.pxi setfiletype clojure
autocmd! BufNewFile,bufRead *.vala,*.groovy set tabstop=4|set shiftwidth=4|set expandtab
autocmd! BufNewFile,bufRead *.go set tabstop=3|set shiftwidth=3
autocmd! BufNewFile,bufRead *.json set tabstop=2|set shiftwidth=2|set expandtab
autocmd! BufNewFile,bufRead *.html set tabstop=2|set shiftwidth=2|set expandtab
augroup END

