
module Main (main) where

import Options.Applicative
import CmdLine

import AppEnv
import AppM
import Core.Types (JVMCmdLine(..), Property(..))
import AppCapability.ExeWASAdminCommand()
import Core.WasSupervision (changeJVMParameters)

main :: IO ()
main = void $ execParser cmdOptions >>= mkAppEnv >>= \env -> runAppM env $ changeJVMParameters $ JVMCmdLineProperty $ Property "M" "MM"
