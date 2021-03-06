# -*- sh -*-

# tool config

set -x LESS "-XMcifR"
set -x TZ "Europe/London"

# personal config

set -x GITROOT "git@github.com:ithinkihaveacat"

# fish config

set -g CDPATH . ~
if test -d ~/workspace
  set -g CDPATH $CDPATH ~/workspace
end
if test -d ~/citc
  set -g CDPATH $CDPATH ~/citc
end

# Avoid fish_user_path and instead set PATH directly. fish_user_path can be used
# to share a PATH across shells and invocations if set as a universal variable;
# it isn't very useful otherwise. See
# https://github.com/fish-shell/fish-shell/issues/527#issuecomment-253775156
function append_path
  if begin ; count $argv > /dev/null ; and count $argv[1] > /dev/null ; and test -d $argv[1] ; end
    if not contains $argv[1] $PATH
      set PATH $PATH $argv[1]
    end
  end
end

function prepend_path
  if begin ; count $argv > /dev/null ; and count $argv[1] > /dev/null ; and test -d $argv[1] ; end
    if not contains $argv[1] $PATH
      set PATH $argv[1] $PATH
    end
  end
end

function sourceif
  if test -r $argv[1]
    source $argv[1]
  end
end

# Google Cloud SDK
#
# https://cloud.google.com/sdk/

prepend_path "$HOME/local/go_appengine"
prepend_path "$HOME/local/google-cloud-sdk/platform/google_appengine/goroot/bin"
prepend_path "$HOME/local/google-cloud-sdk/platform/google_appengine"
prepend_path "$HOME/local/google-cloud-sdk/bin"

# java
#
# 1. Choose JRE from
#    http://www.oracle.com/technetwork/java/javase/downloads/index.html
# 2. Download the *.tar.gz.
# 3. Extract to ~/local.

set d ~/local/jre*/Contents/Home/bin
prepend_path $d

# ghc
#
# Install via:
#
#   $ brew cask install ghc
#
# Then:
#
#   $ cabal update
#   $ cabal install pandoc

set d /Applications/ghc-*.app/Contents/bin
prepend_path $d
prepend_path ~/.cabal/bin

# Android Tools

test -d ~/Library/Android/sdk ; and set -x ANDROID_HOME ~/Library/Android/sdk
test -d ~/Android/Sdk         ; and set -x ANDROID_HOME ~/Android/Sdk

prepend_path $ANDROID_HOME/platform-tools
prepend_path $ANDROID_HOME/tools
prepend_path $ANDROID_HOME/tools/bin

# Ruby
#
# Install gems via:
#
#   $ gem install $name --user-install

set d ~/.gem/ruby/*/bin
prepend_path $d

# Node
#
# NODE_VERSIONS is used by direnv and nodejs-install to make different
# versions of node available; see ~/.direnvrc

set -x NODE_VERSIONS $HOME/.local/share/node/versions
mkdir -p $NODE_VERSIONS

prepend_path $NODE_VERSIONS/(ls $NODE_VERSIONS | sort -V | tail -1)/bin

prepend_path /usr/local/sbin
prepend_path /usr/local/bin

prepend_path "$HOME/local/homebrew/bin"
prepend_path "$HOME/local/homebrew/sbin"
prepend_path (realpath "$HOME/.dotfiles/fish/../bin")
prepend_path "$HOME/local-linux/bin" # $PLATFORM is not readily available, so hardcode
prepend_path "$HOME/local/bin"

# golang
#
# (Needs to be configured after homebrew paths set.)

# Special-case PATH for Ubuntu (package is golang-*-go)
set d /usr/lib/go-*/bin
prepend_path $d

if type -q go
  set -x GOPATH ~/local/go
  mkdir -p $GOPATH
  prepend_path $GOPATH/bin
end

# http://fishshell.com/docs/current/faq.html#faq-greeting
set fish_greeting

# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
set -g __fish_git_prompt_showupstream "auto"
set -g __fish_git_prompt_showstashstate "1"
set -g __fish_git_prompt_showdirtystate "1"

# mkdir -p ~/.rubies
# . $HOME/.config/fish/rubies.fish

# https://github.com/zimbatm/direnv
if type -q direnv
  eval (direnv hook fish)
  # If MANPATH is set, man very helpfully ignores the default search path as defined in
  # /etc/manpath.config (at least on Linux). Therefore, to ensure man searches through
  # the default after direnv fiddles with MANPATH, we explicitly set it to its default value.
  # See http://unix.stackexchange.com/q/344603/49703
  set -x MANPATH (man -w)
end

if type -q jed
  set -x EDITOR "jed"
end

set -x VISUAL $EDITOR

#if type -q code
#  set -x VISUAL "code -w"
#end

type -q pbcopy  ; or alias pbcopy  "xsel -bi"
type -q pbpaste ; or alias pbpaste "xsel -bo"

. ~/.config/fish/solarized.fish
. ~/.config/fish/ua.fish

sourceif ~/.ssh/etc/fish/envrc
