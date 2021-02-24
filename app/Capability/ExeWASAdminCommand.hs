-- | This module implements the capability specified within the library src tree
-- for executing WAS admin commands

module Capability.ExeWASAdminCommand where

import Env
import Capability.CookieJar
import Capability.ExeWASAdminCommand

class Monad m => AuthM m where
  welcome :: (HasConfig m, Monad m) => m CookieJar
  login :: (HasConfig m, Monad m) => m (AuthState)

class AuthM m => ServerM m where
  list :: (HasConfig m, AuthM m) => m ByteString
  exec :: (HasConfig m, AuthM m) => ByteString -> m ByteString

class ServerM => JVMM m where
  updateJvmGenericParameter :: (HasConfig m, ServerM m) => m ByteString
