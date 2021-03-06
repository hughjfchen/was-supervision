-- | This module define a wrapper type of CookieJar

module Core.MyCookieJar
  ( MyCookieJar(..)
  , getCookieJar
  , setCookieJar
  , emptyCookieJar
  , mergeCookieJar
  ) where

import Network.HTTP.Client (CookieJar, createCookieJar)

newtype MyCookieJar = MyCookieJar { unMyCookieJar :: IORef CookieJar }

getCookieJar :: (MonadIO m) => MyCookieJar -> m CookieJar
getCookieJar = readIORef . unMyCookieJar

setCookieJar :: (MonadIO m) => CookieJar -> MyCookieJar -> m ()
setCookieJar cj mycj = atomicModifyIORef (unMyCookieJar mycj) $ const (cj, ())

emptyCookieJar :: (MonadIO m) => m MyCookieJar
emptyCookieJar = newIORef (createCookieJar []) >>= (pure . MyCookieJar)

mergeCookieJar :: (MonadIO m) => CookieJar -> MyCookieJar -> m ()
mergeCookieJar cj mycj = atomicModifyIORef (unMyCookieJar mycj) (\a -> (a <> cj, ()))
