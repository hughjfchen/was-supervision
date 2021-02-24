{- |
Copyright: (c) 2020 Hugh JF Chen
SPDX-License-Identifier: MIT
Maintainer: Hugh JF Chen <hugh.jf.chen@gmail.com>

Take the provision of a WebSphere cell.
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}

module Core.WasSupervision
       ( changeJVMParameters
       ) where

import Control.Monad.Reader (MonadReader, ask)
import Control.Monad (forM)
import Core.Types (JVMCmdLine(..))

import Env
import Capability.CookieJar
import Capability.ExeWASAdminCommand

changeJVMParameters :: (MonadReader env m, HasConnectionInfo env
                       , HasAuthInfo env, JVMM m, RWCookieJarM m)
                    => JVMCmdLine
                    -> m [JVMUpdateState]
changeJVMParameters jvmCmd = do
  env <- ask
  let cInfo = getConnectionInfo env
      aInfo = getAuthInfo env
  authed <- welcome cInfo >>= login cInfo aInfo
  servers <- listServers cInfo authed
  forM servers $ updateTheJVM cInfo authed
  where updateTheJVM c a s = pickServer c a s >>= pickJvm c a
          >>= \j -> updateJvmGenericParameter c a j jvmCmd
