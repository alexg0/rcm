module Test.Main where

import Test.Hspec
import Test.LsrcSpecs (lsrcSpecs)
import Test.UtilSpecs (utilSpecs)
import Test.GetOptSpecs (getOptSpecs)
import Test.DotfilesSpecs (dotfilesSpecs)
import Test.RcrcSpecs (rcrcSpecs)

main = hspec $ do
  lsrcSpecs
  utilSpecs
  getOptSpecs
  dotfilesSpecs
  rcrcSpecs