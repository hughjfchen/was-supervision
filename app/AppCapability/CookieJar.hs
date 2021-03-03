-- | This module define a spec of CookieJar capability

module AppCapability.CookieJar
( getCookieJar
  , setCookieJar
  , emptyCookieJar
  , mergeCookieJar
  ) where

import Network.HTTP.Client (createCookieJar)

import Capability.CookieJar
import AppM

instance ReadCookieJarM (AppM err env) where
  getCookieJar a = readIORef $ unMyCookieJar a

instance RWCookieJarM  (AppM err env) where
  setCookieJar cj mycj = atomicModifyIORef (unMyCookieJar mycj) $ const (cj, ())
  emptyCookieJar = newIORef (createCookieJar []) >>= (pure . MyCookieJar)
  mergeCookieJar cj mycj = atomicModifyIORef (unMyCookieJar mycj) (\a -> (a <> cj, ()))
