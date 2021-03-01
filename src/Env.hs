-- | This module define the Env which contains all the Environment, including
-- | Config, State, Mutable and/or Effect Intepreter functions.

module Env
( ConnectionInfo(..)
  , AuthInfo(..)
  , Env(..)
  , HasConnectionInfo(..)
  , HasAuthInfo(..)
  ) where


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
  }

class HasConnectionInfo a where
  getConnectionInfo :: a -> ConnectionInfo

instance HasConnectionInfo Env where
  getConnectionInfo = envConnectionInfo

instance HasConnectionInfo ConnectionInfo where
  getConnectionInfo = id

class HasAuthInfo a where
  getAuthInfo :: a -> AuthInfo

instance HasAuthInfo Env where
  getAuthInfo = envAuthInfo

instance HasAuthInfo AuthInfo where
  getAuthInfo = id
