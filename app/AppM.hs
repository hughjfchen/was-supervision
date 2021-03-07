-- | This module construct the application monad by specializing the
-- general monad stack

module AppM
  ( AppM )
where

import Core.MyError
import Core.MyHas
import MonadStack

type AppM = MonadStack MyError Env
