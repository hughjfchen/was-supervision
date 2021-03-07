-- |  This module defines the authentication information for
-- http requests.

module Core.AuthInfo
( AuthInfo(..)
  ) where


data AuthInfo = AuthInfo {
  aiAdminUser :: !Text
  , aiAdminPassword :: !Text
  }
