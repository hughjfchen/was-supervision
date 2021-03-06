-- | This module define the specific Env for my application

{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DataKinds #-}

module Core.MyHas
( ConnectionInfo(..)
  , AuthInfo(..)
  , MyCookieJar(..)
  , Env(..)
  ) where

import Has

import Network.HTTP.Client (CookieJar)

data ConnectionInfo = ConnectionInfo {
  ciHost :: !Text
  , ciPort :: !Int
  }

data AuthInfo = AuthInfo {
  aiAdminUser :: !Text
  , aiAdminPassword :: !Text
  }

newtype MyCookieJar = MyCookieJar { unMyCookieJar :: IORef CookieJar }

data Env = Env {
  envConnectionInfo :: ConnectionInfo
  , envAuthInfo :: AuthInfo
  , envMyCookieJar :: MyCookieJar
  } deriving (Has ConnectionInfo) via Field "envConnectionInfo" Env
    deriving (Has AuthInfo) via Field "envAuthInfo" Env
