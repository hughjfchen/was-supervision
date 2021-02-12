-- | This module define specs for executing WAS admin commands

{-# LANGUAGE FlexibleContexts #-}

module Capability.ExeWASAdminCommand
  ( AuthM
  , ServerM
  , JVMM
  , welcome
  , login
  , list
  , pick
  , updateJvmGenericParameter
  , WelcomeState(..)
  , AuthState(..)
  ) where

import Data.Text
import Data.ByteString

import Env
import Capability.CookieJar (MyCookieJar)

type UserName = Text
data WelcomeState = NotSecure MyCookieJar
                  | Secure MyCookieJar
                  | Unknown MyCookieJar

data AuthState = UserNameEmpty
                | PasswordEmpty UserName
                | PasswordNotMatch UserName
                | UserAlreadyLogined UserName
                | Authed MyCookieJar

class (Monad m) => AuthM m where
  welcome :: Config -> m WelcomeState
  login :: Config -> m AuthState

class (AuthM m) => ServerM m where
  list :: Config -> m ByteString
  pick :: Config -> ByteString -> m ByteString

class (ServerM m) => JVMM m where
  updateJvmGenericParameter :: Config -> ByteString -> m ByteString
