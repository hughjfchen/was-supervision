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

import Core.Types (JVMCmdLine(..))

import Env
import Capability.CookieJar
import Capability.ExeWASAdminCommand

changeJVMParameters :: (MonadReader env m, HasConnectionInfo env
                       , HasAuthInfo env, JVMM m, RWCookieJarM m)
                    => JVMCmdLine
                    -> m [JVMUpdateState]
changeJVMParameters jvmCmd = do
  emptyMyCJ <- emptyCookieJar
  env <- ask
  let cInfo = getConnectionInfo env
      aInfo = getAuthInfo env
  authed <- welcome cInfo emptyMyCJ >>= login cInfo emptyMyCJ aInfo
  servers <- listServers cInfo emptyMyCJ authed
  forM servers $ updateTheJVM cInfo emptyMyCJ authed
  where updateTheJVM c a cj s = pickServer c a cj s >>= pickJvm c a cj
          >>= \j -> updateJvmGenericParameter c a cj j jvmCmd
