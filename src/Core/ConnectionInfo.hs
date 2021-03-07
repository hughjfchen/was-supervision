-- | This module defines the type of the connection information
-- for http request.

module Core.ConnectionInfo
( ConnectionInfo(..)
  ) where


data ConnectionInfo = ConnectionInfo {
  ciHost :: !Text
  , ciPort :: !Int
  }
