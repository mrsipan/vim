#!/bin/bash -vex

declare -a giturls
giturls=(
  git://github.com/tpope/vim-surround.git
  git://github.com/tpope/vim-unimpaired.git
  git://github.com/tpope/vim-commentary.git
  git://github.com/tpope/vim-eunuch.git
  git://github.com/kien/ctrlp.vim.git
  git://github.com/msanders/snipmate.vim.git
  git://github.com/Lokaltog/vim-easymotion.git
  git://github.com/scrooloose/nerdtree.git
  git://github.com/tpope/vim-fugitive.git
  git://github.com/kien/tabman.vim.git
  git://github.com/kien/rainbow_parentheses.vim.git
  git://github.com/tpope/vim-obsession.git
  git://github.com/jpo/vim-railscasts-theme.git
  git://github.com/mrsipan/vim-sipan-theme.git
  git://github.com/mrsipan/vim-simple8-theme.git
  git://github.com/nelstrom/vim-mac-classic-theme.git
  git://github.com/tpope/vim-pastie.git
  git://github.com/tpope/vim-repeat.git
  git://github.com/tpope/vim-abolish.git
  git://github.com/vim-scripts/YankRing.vim.git
  git://github.com/vim-scripts/Auto-Pairs.git
  git://github.com/derekwyatt/vim-scala.git
  git://github.com/rodjek/vim-puppet.git
  git://github.com/mrsipan/vim-rust.git
  git://github.com/mrsipan/vim-rst.git
  git://github.com/mrsipan/vim-python.git
  git://github.com/vim-pandoc/vim-pandoc.git
  git://github.com/tkztmk/vim-vala.git
  git://github.com/scrooloose/syntastic.git
  git://github.com/majutsushi/tagbar.git
  git://github.com/tpope/vim-fireplace.git
  git://github.com/tpope/vim-classpath.git
  git://github.com/guns/vim-clojure-static.git
  git://github.com/guns/vim-clojure-highlight.git
)

update_git() {
  local pkgname=$1
  local here=`pwd`

  if [ -d $pkgname ]; then
    cd $pkgname
    git pull
    ls -1 [Mm]akefile.in > /dev/null 2>&1 && {
      autoconf
      ./configure
    }
    ls -1 [Mm]akefile > /dev/null 2>&1 && {
      make clean
      make
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
  https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim \
  -P autoload

cd bundle

for giturl in "${giturls[@]}"; do
  printf "Working on: %s\n\n" $giturl
  download "$giturl"
done
