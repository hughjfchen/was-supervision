-- | This module defines types which shared by lib and exe

{-# LANGUAGE DerivingStrategies #-}

module Types
        ( CmdOptions(..)
        )
where

import Data.Text

data CmdOptions = CmdOptions { cmdHost :: Text
                             , cmdPort :: Int
                             , cmdUserName :: Text
                             , cmdPassword :: Text
                             } deriving stock (Show)
