#!/bin/bash -vex

declare -a giturls

giturls=(
  # git://github.com/5long/pytest-vim-compiler.git
  # git://github.com/ConradIrwin/vim-bracketed-paste
  # git://github.com/fatih/vim-go.git
  # https://github.com/AndrewRadev/linediff.vim.git
  # https://github.com/clojure-vim/clojure.vim.git
  # https://github.com/dag/vim-fish.git
  # https://github.com/guns/vim-clojure-highlight.git
  # https://github.com/jamessan/vim-gnupg.git
  # https://github.com/jupyter-vim/jupyter-vim.git
  # https://github.com/tpope/vim-fireplace.git
  # https://github.com/wlangstroth/vim-racket.git
  https://github.com/AndrewRadev/splitjoin.vim.git
  https://github.com/JuliaEditorSupport/julia-vim.git
  https://github.com/SirVer/ultisnips.git
  https://github.com/airblade/vim-gitgutter.git
  https://github.com/axvr/org.vim.git
  https://github.com/cespare/vim-toml.git
  https://github.com/ctrlpvim/ctrlp.vim.git
  https://github.com/daveyarwood/vim-alda.git
  https://github.com/derekwyatt/vim-scala.git
  https://github.com/dyng/ctrlsf.vim.git
  https://github.com/fsharp/vim-fsharp.git
  https://github.com/guns/vim-sexp.git
  https://github.com/hashivim/vim-terraform.git
  https://github.com/jiangmiao/auto-pairs.git
  https://github.com/jvirtanen/vim-hcl.git
  https://github.com/leafgarland/typescript-vim.git
  https://github.com/liquidz/vim-iced.git
  https://github.com/michaeljsmith/vim-indent-object.git
  https://github.com/mrsipan/ctrlp-py-matcher.git
  https://github.com/mrsipan/rainbow_parentheses.vim.git
  https://github.com/mrsipan/vim-python.git
  https://github.com/mrsipan/vim-rst.git
  https://github.com/mrsipan/vim-simple8-theme.git
  https://github.com/mrsipan/vim-sipan-theme.git
  https://github.com/pangloss/vim-javascript.git
  https://github.com/reasonml-editor/vim-reason-plus.git
  https://github.com/tmhedberg/matchit.git
  https://github.com/tommcdo/vim-exchange.git
  https://github.com/tpope/vim-classpath.git
  https://github.com/tpope/vim-commentary.git
  https://github.com/tpope/vim-dispatch.git
  https://github.com/tpope/vim-endwise.git
  https://github.com/tpope/vim-eunuch.git
  https://github.com/tpope/vim-repeat.git
  https://github.com/tpope/vim-speeddating.git
  https://github.com/tpope/vim-surround.git
  https://github.com/tpope/vim-vinegar.git
  https://github.com/vim-ruby/vim-ruby.git
  https://github.com/vim-scripts/YankRing.vim.git
  https://github.com/vim-scripts/confluencewiki.vim.git
  https://github.com/vim-syntastic/syntastic.git
)

update_git() {
  local pkgname=$1
  local here=`pwd`

  if [ -d $pkgname ]; then
    cd $pkgname

    local branch_name=`git branch --list master`

    if [ ! -z "$branch_name" ]; then
      git pull origin master
    else
      git pull origin main
    fi

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
