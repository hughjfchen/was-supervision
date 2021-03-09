-- | This module define the Env for application

{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DataKinds #-}

module AppEnv (
  AppEnv(..)
  , mkAppEnv
  ) where

import Core.ConnectionInfo
import Core.AuthInfo
import Core.MyCookieJar
import Has

import CmdLine (CmdOptions(..))

data AppEnv = AppEnv {
  envConnectionInfo :: ConnectionInfo
  , envAuthInfo :: AuthInfo
  , envMyCookieJar :: MyCookieJar
  }
    deriving (Has ConnectionInfo) via Field "envConnectionInfo" AppEnv
    deriving (Has AuthInfo) via Field "envAuthInfo" AppEnv
    deriving (Has MyCookieJar) via Field "envMyCookieJar" AppEnv


mkAppEnv :: (MonadIO m) => CmdOptions -> m AppEnv
mkAppEnv cmdOptions = emptyCookieJar >>= \empCJ -> pure $ AppEnv {
                                                            envConnectionInfo = ConnectionInfo {
                                                                ciHost = cmdHost cmdOptions
                                                                , ciPort = cmdPort cmdOptions }
                                                            , envAuthInfo = AuthInfo {
                                                                aiAdminUser = cmdUserName cmdOptions
                                                                , aiAdminPassword = cmdPassword cmdOptions
                                                                }
                                                            , envMyCookieJar = empCJ
                                                            }
