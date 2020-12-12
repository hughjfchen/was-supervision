
module Main (main) where

import Options.Applicative
import CmdLine

import WasSupervision (changeJVMParameters)

main :: IO ()
main = execParser cmdOptions >>= changeJVMParameters
