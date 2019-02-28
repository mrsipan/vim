#!/bin/bash -vex

declare -a giturls

giturls=(
  git://github.com/AndrewRadev/linediff.vim.git
  git://github.com/AndrewRadev/splitjoin.vim.git
  git://github.com/ConradIrwin/vim-bracketed-paste
  git://github.com/ElmCast/elm-vim.git
  git://github.com/SirVer/ultisnips.git
  git://github.com/airblade/vim-gitgutter.git
  git://github.com/cespare/vim-toml.git
  git://github.com/ctrlpvim/ctrlp.vim.git
  git://github.com/derekwyatt/vim-scala.git
  git://github.com/fatih/vim-go.git
  git://github.com/fsharp/vim-fsharp.git
  git://github.com/guns/vim-clojure-highlight.git
  git://github.com/guns/vim-sexp.git
  git://github.com/hashivim/vim-terraform.git
  git://github.com/jamessan/vim-gnupg.git
  git://github.com/jceb/vim-orgmode.git
  git://github.com/kien/rainbow_parentheses.vim.git
  git://github.com/mileszs/ack.vim.git
  git://github.com/mrsipan/ctrlp-py-matcher.git
  git://github.com/mrsipan/vim-python.git
  git://github.com/mrsipan/vim-rst.git
  git://github.com/mrsipan/vim-simple8-theme.git
  git://github.com/mrsipan/vim-sipan-theme.git
  git://github.com/pangloss/vim-javascript.git
  git://github.com/tmhedberg/matchit.git
  git://github.com/tommcdo/vim-exchange.git
  git://github.com/tpope/vim-classpath.git
  git://github.com/tpope/vim-commentary.git
  git://github.com/tpope/vim-endwise.git
  git://github.com/tpope/vim-eunuch.git
  git://github.com/tpope/vim-fireplace.git
  git://github.com/tpope/vim-fugitive.git
  git://github.com/tpope/vim-repeat.git
  git://github.com/tpope/vim-surround.git
  git://github.com/tpope/vim-unimpaired.git
  git://github.com/tpope/vim-vinegar.git
  git://github.com/vim-ruby/vim-ruby.git
  git://github.com/vim-scripts/Auto-Pairs.git
  git://github.com/vim-scripts/YankRing.vim.git
  git://github.com/vim-syntastic/syntastic.git
)

update_git() {
  local pkgname=$1
  local here=`pwd`

  if [ -d $pkgname ]; then
    cd $pkgname
    git pull origin master
    ls -1 [Mm]akefile.in > /dev/null 2>&1 && {
      autoconf
      ./configure
    }
    ls -1 [Mm]akefile > /dev/null 2>&1 && {
      if [ $pkgname = 'vim-go' ]; then
        printf "%s\n" "Do not run vim-go tests"
        cd $here
        return
      fi
      make clean || true
      make install || true
    }
    cd $here
    return 0
  fi
}

get_pkgname() {
  local giturl=$1
  printf "%s" $giturl | sed 's/git:\/\/.*\/\([^/]*\)\.git/\1/'
}

use_branch_or_tag() {
  local projname=$1
  local use=$2

  printf "using tag/branch $use in project $projname\n"

  cd $projname
  git pull
  git checkout $2
  cd ..
  update_git $projname
}

download() {
  local giturl=$1
  local pkgname=`get_pkgname $giturl`

  if [ -d $pkgname ]; then
    update_git $pkgname
  else
    [ -f $pkgname ] && rm -rf $pkgname
    git clone $giturl
    update_git $pkgname
  fi
  return 0
}

check_availability() {
  for toolname in "${@}"; do
    which $toolname > /dev/null 2>&1 || { printf "Missing \"%s\". Exiting.\n" "$toolname"; exit 5; }
  done
  return 0
}

check_availability make git

mkdir -p bundle autoload tmp

# download pathogen
wget --no-check-certificate \
  https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim \
  -P autoload

cd bundle

for giturl in "${giturls[@]}"; do
  printf "Working on: %s\n\n" $giturl
  download "$giturl"
done

test -h "$HOME/.vimrc" && rm "$HOME/.vimrc"
test -h "$HOME/.gvimrc" && rm "$HOME/.gvimrc"

ln -s $HOME/.vim/vimrc $HOME/.vimrc
ln -s $HOME/.vim/gvimrc $HOME/.gvimrc
