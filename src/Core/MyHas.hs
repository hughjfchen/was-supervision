-- | This module define the specific Env for my application

{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE DataKinds #-}

module Core.MyHas
( ConnectionInfo(..)
  , AuthInfo(..)
  , Env(..)
  ) where

import Has

import Core.MyCookieJar

data ConnectionInfo = ConnectionInfo {
  ciHost :: !Text
  , ciPort :: !Int
  }

data AuthInfo = AuthInfo {
  aiAdminUser :: !Text
  , aiAdminPassword :: !Text
  }

data Env = Env {
  envConnectionInfo :: ConnectionInfo
  , envAuthInfo :: AuthInfo
  , envMyCookieJar :: MyCookieJar
  }
    deriving (Has ConnectionInfo) via Field "envConnectionInfo" Env
    deriving (Has AuthInfo) via Field "envAuthInfo" Env
    deriving (Has MyCookieJar) via Field "envMyCookieJar" Env

-- instance Has ConnectionInfo Env where
--   obtain :: Env -> ConnectionInfo
--   obtain = envConnectionInfo

-- instance Has AuthInfo Env where
--   obtain :: Env -> AuthInfo
--   obtain = envAuthInfo

-- instance Has MyCookieJar Env where
--   obtain :: Env -> MyCookieJar
--   obtain = envMyCookieJar
