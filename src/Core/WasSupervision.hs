{- |
Copyright: (c) 2020 Hugh JF Chen
SPDX-License-Identifier: MIT
Maintainer: Hugh JF Chen <hugh.jf.chen@gmail.com>

Take the provision of a WebSphere cell.
-}

module Core.WasSupervision
       ( changeJVMParameters
       ) where

import Core.Types (JVMCmdLine(..))

import Has
import Core.MyHas
import Error
import Core.MyError
import Core.MyCookieJar
import Capability.ExeWASAdminCommand

changeJVMParameters :: (WithError MyError m, MonadReader env m
                       , Has ConnectionInfo env, Has AuthInfo env, JVMM m, Has MyCookieJar env)
                    => JVMCmdLine
                    -> m [JVMUpdateState]
changeJVMParameters jvmCmd = welcome >> login >> listServers >>= changeAllJvmPara
  where changeAllJvmPara = mapM  (\y -> pickServer y >>= pickJvm >>= flip updateJvmGenericParameter jvmCmd)
