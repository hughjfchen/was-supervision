-- | This module define the specific Env for my application

{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DataKinds #-}

module Core.MyHas
  ( Env(..)
  ) where

import Has

import Core.MyCookieJar
import Core.ConnectionInfo
import Core.AuthInfo

data Env = Env {
  envConnectionInfo :: ConnectionInfo
  , envAuthInfo :: AuthInfo
  , envMyCookieJar :: MyCookieJar
  }
    deriving (Has ConnectionInfo) via Field "envConnectionInfo" Env
    deriving (Has AuthInfo) via Field "envAuthInfo" Env
    deriving (Has MyCookieJar) via Field "envMyCookieJar" Env
