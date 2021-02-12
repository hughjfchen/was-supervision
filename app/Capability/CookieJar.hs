-- | This module define a spec of CookieJar capability

module Capability.CookieJar where


import Network.HttpType

newtype CookieJar = CookieJar { unCookieJar :: !(IORef CookieJar) }

class Monad m => ReadCookieJarM m where
  getCookieJar :: m CookieJar

class ReadCookieJarM m => RWCookieJarM m where
  setCookieJar :: CookieJar -> m CookieJar
  emptyCookieJar :: m CookieJar
  mergeCookieJar :: CookieJar -> CookieJar -> m CookieJar
