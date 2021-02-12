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

import Data.IORef
import Network.HTTP.Client (CookieJar)

newtype MyCookieJar = MyCookieJar { unMyCookieJar :: IORef CookieJar }

class Monad m => ReadCookieJarM m where
  getCookieJar :: m CookieJar

class ReadCookieJarM m => RWCookieJarM m where
  setCookieJar :: CookieJar -> m CookieJar
  emptyCookieJar :: m CookieJar
  mergeCookieJar :: CookieJar -> CookieJar -> m CookieJar

-- >>> :hgr IORef a
-- Can't Access `https://hoogle.haskell.org/?hoogle=IORef%20a'
-- Alert!: Unable to access document.
-- lynx: Can't access startfile
