-- | This module defines types which shared by lib and exe

{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}

module Core.Types(
  CmdOptions(..)
  , SwitchName(..)
  , Switch(..)
  , OptionName(..)
  , Option(..)
  , Property(..)
  , JVMCmdLine(..)
  , toJVMCmdLine
            ) where

import Data.Text

data CmdOptions = CmdOptions { cmdHost :: !Text
                             , cmdPort :: !Int
                             , cmdUserName :: !Text
                             , cmdPassword :: !Text
                             } deriving stock (Show)

data SwitchName = VerboseGC
                | VerboseClass
                | VerboseModule
                | VerboseJNI
                | Xint
                | Xrs
                | Xnoclassgc
                deriving stock (Show)

newtype Switch = Switch SwitchName deriving stock (Show)

showSwitch :: Switch -> Text
showSwitch (Switch VerboseGC) = "verbose:gc"
showSwitch (Switch VerboseClass) = "verbose:class"
showSwitch (Switch VerboseModule) = "verbose:module"
showSwitch (Switch VerboseJNI) = "verbose:jni"
showSwitch (Switch Xint) = "Xint"
showSwitch (Switch Xrs) = "Xrs"
showSwitch (Switch Xnoclassgc) = "Xnoclassgc"

data OptionName = Xms
                | Xmx
                | Xloggc
                deriving stock (Show)
type OptionValue = Text
data Option = Option OptionName OptionValue deriving stock (Show)

showOption :: Option -> Text
showOption (Option Xms v) = "Xms" <> v
showOption (Option Xmx v) = "Xmx" <> v
showOption (Option Xloggc v) = "Xloggc:" <> v

type PropertyName = Text
type PropertyValue = Text
data Property = Property PropertyName PropertyValue

data JVMCmdLine = JVMCmdLineSwitch Switch
                | JVMCmdLineOption Option
                | JVMCmdLineProperty Property

toJVMCmdLine :: JVMCmdLine -> Text
toJVMCmdLine (JVMCmdLineSwitch s) = "-" <> showSwitch s
toJVMCmdLine (JVMCmdLineOption (Option _ "")) = ""
toJVMCmdLine (JVMCmdLineOption o) = "-" <> showOption o

toJVMCmdLine (JVMCmdLineProperty (Property "" "")) = ""
toJVMCmdLine (JVMCmdLineProperty (Property "" _)) = ""
toJVMCmdLine (JVMCmdLineProperty (Property _ "")) = ""
toJVMCmdLine (JVMCmdLineProperty (Property n v)) = "-D"
                                        <> n
                                        <> "="
                                        <> v
