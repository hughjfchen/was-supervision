-- | This module construct the application monad

module AppM
( AppM(..)
  , runApp
  , runAppAsIO
 )
where

import Control.Exception (try, throwIO, catch)
import Control.Monad.Except (MonadError(..))
import Relude.Extra.Bifunctor (firstF)
import Error

newtype AppM err env a = AppM { unAppM :: ReaderT env IO a }
                        deriving newtype (Functor, Applicative, Monad
                                        , MonadFail, MonadReader env
                                        , MonadIO)

{- | This instance allows to throw and catch errors that are visible in type
definitions. The implementation relies on underlying 'IO' machinery.
Use 'CakeSlayer.Error.throwError' and 'CakeSlayer.Error.catchError': these
functions automatically attach source code positions to errors.
-}
instance (Show err, Typeable err)
    => MonadError (ErrorWithSource err) (AppM err env)
  where
    throwError :: ErrorWithSource err -> AppM err env a
    throwError = liftIO . throwIO . AppException
    {-# INLINE throwError #-}

    catchError
        :: AppM err env a
        -> (ErrorWithSource err -> AppM err env a)
        -> AppM err env a
    catchError action handler = AppM $ ReaderT $ \env -> do
        let ioAction = runApp env action
        ioAction `catch` \(AppException e) -> runApp env $ handler e
    {-# INLINE catchError #-}

{- | Run application by providing environment.
Throws 'AppException' if application has unhandled 'throwError'. Use
'runAppAsIO' to handle exceptions as well.
-}
runApp :: env -> AppM err env a -> IO a
runApp env = usingReaderT env . unAppM
{-# INLINE runApp #-}

{- | Like 'runApp' but also catches 'AppException' and unwraps 'ErrorWithSource'
from it. Use this function to handle errors outside 'App' monad.
-}
runAppAsIO
    :: (Show err, Typeable err)
    => env
    -> AppM err env a
    -> IO (Either (ErrorWithSource err) a)
runAppAsIO env = firstF unAppException . try . runApp env
{-# INLINE runAppAsIO #-}
