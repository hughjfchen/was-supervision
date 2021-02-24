-- | This module parse the command line for the parameters
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}

module CmdLine
( cmdOptions
 )
where

import Options.Applicative

import Paths_was_supervision (version)
import Data.Version (showVersion)

import Core.Types (CmdOptions(..))

versionOptionParser :: Parser (a -> a)
versionOptionParser = infoOption (showVersion version)
                        (long "version" <> short 'v' <> help "Show version")

cmdOptionsParser :: Parser CmdOptions
cmdOptionsParser = CmdOptions
  <$> strOption
               ( long "host"
               <> short 'm'
               <> metavar "HOST"
               <> value "localhost"
               <> showDefault
               <> help "The hostname/IP/DNS name of the websphere dmgr.")
  <*> option auto
               ( long "port"
               <> short 'p'
               <> metavar "PORT"
               <> value 9060
               <> showDefault
               <> help "The port number of the websphere dmgr.")
  <*> strOption
               ( long "username"
               <> short 'u'
               <> metavar "USERNAME"
               <> help "The username for access to the websphere admin console.")
  <*> strOption
              ( long "password"
              <> short 'w'
              <> metavar "PASSWORD"
              <> help "The password for access to the websphere admin console.")

cmdOptions :: ParserInfo CmdOptions
cmdOptions = info (cmdOptionsParser <**> helper <**> versionOptionParser)
                ( fullDesc
                <> progDesc "Config websphere admin console via command line."
                <> header ("was-supervision " <> showVersion version <> " - config websphere via command line."))
