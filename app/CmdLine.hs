-- | This module parse the command line for the parameters
{-# LANGUAGE DerivingStrategies #-}

module CmdLine
( cmdOptions
 , CmdOptions(..)
 )
where

import Data.Text
import Options.Applicative

data CmdOptions = CmdOptions { cmdHost :: Text
                             , cmdPort :: Int
                             , cmdUserName :: Text
                             , cmdPassword :: Text
                             } deriving stock (Show)

cmdOptionsParser :: Parser CmdOptions
cmdOptionsParser = CmdOptions
  <$> (strOption
               ( long "host"
               <> short 'm'
               <> metavar "HOST"
               <> help "The hostname/IP/DNS name of the websphere dmgr."))
  <*> (option auto
               ( long "port"
               <> short 'p'
               <> metavar "PORT"
               <> help "The port number of the websphere dmgr."))
  <*> (strOption
               ( long "username"
               <> short 'u'
               <> metavar "USERNAME"
               <> help "The username for access to the websphere admin console."))
  <*> (strOption
              ( long "password"
              <> short 'w'
              <> metavar "PASSWORD"
              <> help "The password for access to the websphere admin console."))

cmdOptions :: ParserInfo CmdOptions
cmdOptions = info (cmdOptionsParser <**> helper)
                ( fullDesc
                <> progDesc "Config websphere admin console via command line."
                <> header "was-supervision - config websphere via command linve.")
