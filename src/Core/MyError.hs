-- | This module defines the application related business errors.

module Core.MyError
( MyError(..)
  ) where

data MyError = GeneralError Text
              | NotSecure Text
              | NotFound Text
              | UserNameEmpty
              | PasswordEmpty Text
              | PasswordNotMatch Text
              | UserAlreadyLogined Text
              | PreSessionChangeNotSaved Text
              | ChangeNotSaved Text
              | JVMParametersExist Text
              deriving stock (Show, Typeable)
