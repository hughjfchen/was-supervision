-- | This module parse the command line for the parameters
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module AppM
( AppM(..)
 )
where

import Control.Monad.Reader (ReaderT, MonadReader)
import Control.Monad.IO.Class (MonadIO)

import Data.Typeable

newtype AppM err env a = AppM { unAppM :: ReaderT env IO a }
                        deriving newtype (Functor, Applicative, Monad
                                        , MonadFail, MonadReader env
                                        , MonadIO)

{- | Run application by providing environment.
Throws 'AppException' if application has unhandled 'throwError'. Use
'runAppAsIO' to handle exceptions as well.
-}
runApp :: env -> AppM err env a -> IO a
runApp env = usingReaderT env . unApp
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

