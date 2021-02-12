{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Test.Hspec
import Test.Hspec.Hedgehog

import Hedgehog
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range

import Types

main :: IO ()
main = hspec $
  describe "test jvm generic command line" $ do
    it "test property with hedgehog - switch" $ hedgehog $ do
      theSwitchName <- forAll $ Gen.element [VerboseGC, VerboseClass, VerboseModule, VerboseJNI, Xint, Xrs, Xnoclassgc]
      case toJVMCmdLine (JVMCmdLineSwitch $ Switch theSwitchName) of
        "-verbose:gc" -> success
        "-verbose:class" -> success
        "-verbose:module" -> success
        "-verbose:jni" -> success
        "-Xint" -> success
        "-Xrs" -> success
        "-Xnoclassgc" -> success
        _ -> failure
    it "test property with hedgehog - option" $ hedgehog $ do
      theOptionName <- forAll $ Gen.element [Xms, Xmx, Xloggc]
      theOptionValue <- forAll $ Gen.text (Range.linear 0 100) Gen.unicode
      let optionCmd = toJVMCmdLine (JVMCmdLineOption $ Option theOptionName theOptionValue)
      case theOptionValue of
        "" -> optionCmd === ""
        _ -> case theOptionName of
              Xms -> optionCmd === "-Xms" <> theOptionValue
              Xmx -> optionCmd === "-Xmx" <> theOptionValue
              Xloggc -> optionCmd === "-Xloggc:" <> theOptionValue
    it "test property with hedgehog - property" $ hedgehog $ do
      propertyName <- forAll $ Gen.text (Range.linear 0 100) Gen.unicode
      propertyValue <- forAll $ Gen.text (Range.linear 0 100) Gen.unicode
      let propertyCmd = toJVMCmdLine (JVMCmdLineProperty $ Property propertyName propertyValue)
      case (propertyName, propertyValue) of
        ("", _) -> propertyCmd === ""
        (_, "") -> propertyCmd === ""
        _ -> propertyCmd === "-D" <> propertyName <> "=" <> propertyValue

-- >>> main
-- test jvm generic command line
--   test property with hedgehog - switch
--   test property with hedgehog - option
--   test property with hedgehog - property
-- Finished in 0.0364 seconds
-- 3 examples, 0 failures
