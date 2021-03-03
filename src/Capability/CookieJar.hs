-- | This module define a spec of CookieJar capability

module Capability.CookieJar
  ( MyCookieJar(..)
  , ReadCookieJarM
  , RWCookieJarM
  , getCookieJar
  , setCookieJar
  , emptyCookieJar
  , mergeCookieJar
  ) where

import Network.HTTP.Client (CookieJar)

newtype MyCookieJar = MyCookieJar { unMyCookieJar :: IORef CookieJar }

class Monad m => ReadCookieJarM m where
  getCookieJar :: MyCookieJar -> m CookieJar

class ReadCookieJarM m => RWCookieJarM m where
  setCookieJar :: CookieJar -> MyCookieJar -> m ()
  emptyCookieJar :: m MyCookieJar
  mergeCookieJar :: CookieJar -> MyCookieJar -> m ()
