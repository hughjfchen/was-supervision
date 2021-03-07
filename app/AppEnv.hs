-- | This module define the Env for application

module AppEnv (
  mkAppEnv
  ) where

import Core.MyHas
import Core.MyCookieJar
import Core.ConnectionInfo
import Core.AuthInfo

mkAppEnv :: Env
mkAppEnv = Env {
  envConnectionInfo = ConnectionInfo {
      ciHost = "localhost"
      , ciPort = 9960                                   }
  , envAuthInfo = AuthInfo {
      aiAdminUser = "wasadmin"
      , aiAdminPassword = "wasadmin"
                           }
  , envMyCookieJar = undefined
               }
