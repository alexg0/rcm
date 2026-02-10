  $ . "$TESTDIR/helper.sh"

Without -D, rcdn should not remove managed dangling symlinks

  $ touch .dotfiles/alpha
  > rcup >/dev/null
  > rm .dotfiles/alpha
  > rcdn >/dev/null
  $ assert "alpha should still be a dangling symlink" -h "$HOME/.alpha"

With -D, rcdn should remove managed dangling symlinks

  $ rcdn -D >/dev/null
  $ refute "alpha should be removed when -D is passed" -e "$HOME/.alpha"

With -D, rcdn should keep unmanaged dangling symlinks

  $ ln -s "$HOME/not-managed-target" "$HOME/.outside"
  $ rcdn -D >/dev/null
  $ assert "outside should still be a dangling symlink" -h "$HOME/.outside"

With -D and FILE arguments, cleanup should be restricted to those files

  $ touch .dotfiles/one .dotfiles/two
  > rcup >/dev/null
  > rm .dotfiles/one .dotfiles/two
  $ assert "one should be dangling symlink" -h "$HOME/.one"
  $ assert "two should be dangling symlink" -h "$HOME/.two"
  $ rcdn -D one >/dev/null
  $ refute "one should be removed" -e "$HOME/.one"
  $ assert "two should remain because it was not requested" -h "$HOME/.two"

With -D, rcdn should not remove dangling symlinks inside source dotfiles dirs

  $ ln -s "$HOME/.dotfiles/missing-in-source" "$HOME/.dotfiles/internal-dangling"
  $ rcdn -D >/dev/null
  $ assert "internal source-dir dangling link should not be removed" -h "$HOME/.dotfiles/internal-dangling"
