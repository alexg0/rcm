  $ . "$TESTDIR/helper.sh"

Without -D, rcdn should not remove managed dangling symlinks

  $ touch .dotfiles/alpha
  > rcup >/dev/null
  > rm .dotfiles/alpha
  > rcdn >/dev/null
  $ assert "alpha should still be a dangling symlink" -h "$HOME/.alpha"

With -D, rcdn should remove managed dangling symlinks

  $ rcdn -D >/dev/null
  $ refute "alpha should be removed when -D is passed" -h "$HOME/.alpha"

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
  $ refute "one should be removed" -h "$HOME/.one"
  $ assert "two should remain because it was not requested" -h "$HOME/.two"

With -D, rcdn should not remove dangling symlinks inside source dotfiles dirs

  $ ln -s "$HOME/.dotfiles/missing-in-source" "$HOME/.dotfiles/internal-dangling"
  $ rcdn -D >/dev/null
  $ assert "internal source-dir dangling link should not be removed" -h "$HOME/.dotfiles/internal-dangling"

With -D and multiple FILE arguments, every selected link should be removed

  $ ln -s "$HOME/.dotfiles/first-missing" "$HOME/.first-missing"
  > ln -s "$HOME/.dotfiles/second-missing" "$HOME/.second-missing"
  > rcdn -D first-missing second-missing >/dev/null
  $ refute "first requested link should be removed" -h "$HOME/.first-missing"
  $ refute "second requested link should be removed" -h "$HOME/.second-missing"

With multiple dotfiles roots, cleanup should recognize each root

  $ mkdir "$HOME/other-dotfiles"
  > ln -s "$HOME/.dotfiles/first-root-missing" "$HOME/.first-root-missing"
  > ln -s "$HOME/other-dotfiles/second-root-missing" "$HOME/.second-root-missing"
  > rcdn -D -d "$HOME/.dotfiles" -d "$HOME/other-dotfiles" >/dev/null
  $ refute "link from first root should be removed" -h "$HOME/.first-root-missing"
  $ refute "link from second root should be removed" -h "$HOME/.second-root-missing"

Source directories should remain protected when multiple roots are selected

  $ assert "internal link should remain with multiple selected roots" -h "$HOME/.dotfiles/internal-dangling"

Dangling link names should be read literally

  $ ln -s "$HOME/.dotfiles/missing space" "$HOME/.missing space"
  > ln -s "$HOME/.dotfiles/missing-backslash" "$HOME/.missing\\backslash"
  > rcdn -D >/dev/null
  $ refute "name with spaces should be removed" -h "$HOME/.missing space"
  $ refute "name with a backslash should be removed" -h "$HOME/.missing\\backslash"

Selected file arguments should preserve spaces

  $ ln -s "$HOME/.dotfiles/selected space" "$HOME/.selected space"
  > ln -s "$HOME/.dotfiles/other space" "$HOME/.other space"
  > rcdn -D "selected space" >/dev/null
  $ refute "selected spaced name should be removed" -h "$HOME/.selected space"
  $ assert "unselected spaced name should remain" -h "$HOME/.other space"
