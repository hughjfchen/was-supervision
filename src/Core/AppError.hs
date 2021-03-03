-- | This module defines the application related business errors.

module Core.AppError
( AppError(..)
  ) where

data AppError = NotSecure Text
              | UserAlreadyLogined Text
