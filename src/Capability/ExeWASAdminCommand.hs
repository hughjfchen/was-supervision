-- | This module define specs for executing WAS admin commands

{-# LANGUAGE FlexibleContexts #-}

module Capability.ExeWASAdminCommand
  ( AuthM
  , ServerM
  , JVMM
  , Server(..)
  , JVM(..)
  , welcome
  , login
  , listServers
  , pickServer
  , pickJvm
  , updateJvmGenericParameter
  , WelcomeState(..)
  , AuthState(..)
  , JVMUpdateState(..)
  ) where


import Env
import Core.Types (JVMCmdLine)
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

type CellName = Text
type NodeName = Text
type ServerName = Text
type CellID = Text
type NodeID = Text
type ServerID = Text

data Server = Server { cellName :: CellName
                     , cellID :: CellID
                     , nodeName :: NodeName
                     , nodeID :: NodeID
                     , serverName :: ServerName
                     , serverID :: ServerID
                     }

type JVMID = Text
type JVMName = Text

data JVM = JVM { jvmName :: JVMName
               , jvmID :: JVMID
               }

data JVMUpdateState = Success JVM
                    | AlreadyContained JVM
                    | UndeterminableResult JVM

class (Monad m) => AuthM m where
  welcome :: ConnectionInfo -> MyCookieJar -> m WelcomeState
  login :: ConnectionInfo -> MyCookieJar -> AuthInfo -> WelcomeState -> m AuthState

class (AuthM m) => ServerM m where
  listServers :: ConnectionInfo -> MyCookieJar -> AuthState -> m [Server]
  pickServer :: ConnectionInfo -> MyCookieJar -> AuthState -> Server -> m Server

class (ServerM m) => JVMM m where
  pickJvm :: ConnectionInfo -> MyCookieJar -> AuthState -> Server -> m JVM
  updateJvmGenericParameter :: ConnectionInfo
                            -> MyCookieJar
                            -> AuthState
                            -> JVM
                            -> JVMCmdLine
                            -> m JVMUpdateState

