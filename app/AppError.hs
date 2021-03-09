-- | This module defines the application implementation related errors.

module AppError
( AppError(..)
  ) where

import As
import Core.MyError

data AppError = AppInvalidUrlError Text
              | AppHttpError Text
              | AppNotSecure Text
              | AppNotFound Text
              | AppUserNameEmpty
              | AppPasswordEmpty Text
              | AppPasswordNotMatch Text
              | AppUserAlreadyLogined Text
              | AppPreSessionChangeNotSaved Text
              | AppChangeNotSaved Text
              | AppJVMParametersExist Text
              deriving stock (Show, Typeable)

instance As AppError MyError where
  as (NotSecure url) = AppNotSecure url
  as (NotFound url) = AppNotFound url
  as (UserNameEmpty) = AppUserNameEmpty
  as (PasswordEmpty pwd) = AppPasswordEmpty pwd
  as (PasswordNotMatch pwd) = AppPasswordNotMatch pwd
  as (UserAlreadyLogined user) = AppUserAlreadyLogined user
  as (PreSessionChangeNotSaved user) = AppPreSessionChangeNotSaved user
  as (ChangeNotSaved user) = AppChangeNotSaved user
  as (JVMParametersExist jvmpara) = AppJVMParametersExist jvmpara
  match (AppNotSecure url) = Just $ NotSecure url
  match (AppNotFound url) = Just $ NotFound url
  match (AppUserNameEmpty) = Just $ UserNameEmpty
  match (AppPasswordEmpty pwd) = Just $ PasswordEmpty pwd
  match (AppPasswordNotMatch pwd) = Just $ PasswordNotMatch pwd
  match (AppUserAlreadyLogined user) = Just $ UserAlreadyLogined user
  match (AppPreSessionChangeNotSaved user) = Just $ PreSessionChangeNotSaved user
  match (AppChangeNotSaved user) = Just $ ChangeNotSaved user
  match (AppJVMParametersExist jvmpara) = Just $ JVMParametersExist jvmpara
  match (AppInvalidUrlError _) = Nothing
  match (AppHttpError _) = Nothing
