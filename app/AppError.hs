-- | This module defines the application implementation related errors.

module AppError
( AppError(..)
  ) where

import Core.MyError

data AppError = MyError MyError
              | AppInvalidUrlError Text
              | AppHttpError Text
              deriving stock (Show, Typeable)
