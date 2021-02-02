  $ . "$TESTDIR/helper.sh"

Should support wildcards in the excludes, including Emacs backup
files, and wildcards in directory specifier.

  $ rm -rf .dotfiles
  $ ( mkdir .dotfiles && cd .dotfiles && touch included README.md included~ README.md~ )

And the with directory tagged wildcards using -x 

  $ lsrc -x README.md -x "dotfiles:*~"
  /*/.included:/*/.dotfiles/included (glob)

  $ lsrc -x README.md -x "dot*:*~"
  /*/.included:/*/.dotfiles/included (glob)

