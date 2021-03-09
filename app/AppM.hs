-- | This module construct the application monad by specializing the
-- general monad stack

module AppM
  ( AppM
  , runAppM
  )
where

import Core.MyError
import MonadStack

import AppEnv

type AppM = MonadStack MyError AppEnv

runAppM :: AppEnv -> AppM a -> IO a
runAppM = runMonadStack
