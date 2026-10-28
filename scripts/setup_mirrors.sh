#!/bin/sh
set -e
git remote set-url origin git@git.sr.ht:~krisque/dotfiles
git config --unset-all remote.origin.pushurl || true   # makes it safe to re-run
for url in \
  git@git.sr.ht:~krisque/dotfiles \
  git@codeberg.org:Krisque/dotfiles.git \
  git@github.com:chrisemke/dotfiles.git \
  git@gitlab.com:Krisque/dotfiles.git
do
  git remote set-url --add --push origin "$url"
done
git config push.followTags true
