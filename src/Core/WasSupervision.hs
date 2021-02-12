{- |
Copyright: (c) 2020 Hugh JF Chen
SPDX-License-Identifier: MIT
Maintainer: Hugh JF Chen <hugh.jf.chen@gmail.com>

Take the provision of a WebSphere cell.
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}

module Core.WasSupervision
       ( changeJVMParameters
       ) where

import Data.Text (pack)
import Data.Text.Encoding (encodeUtf8)
import Control.Monad.Reader (MonadReader, ask)
import Control.Monad (void)
import Core.Types (JVMCmdLine(..))

import Env
import Capability.CookieJar
import Capability.ExeWASAdminCommand

changeJVMParameters :: (MonadReader env m, HasConfig env, JVMM m, RWCookieJarM m) => JVMCmdLine -> m ()
changeJVMParameters jvmCmd = do
  env <- ask
  let cfg = getConfig env
  server <- welcome cfg >> login cfg >> list cfg >>= pick cfg
  void $ updateJvmGenericParameter cfg $ encodeUtf8 $ pack $ show jvmCmd

-- >>> :hg Text -> ByteString
-- Data.Text.Encoding encodeUtf8 :: Text -> ByteString
-- Data.Text.Encoding encodeUtf16LE :: Text -> ByteString
-- Data.Text.Encoding encodeUtf16BE :: Text -> ByteString
-- Data.Text.Encoding encodeUtf32LE :: Text -> ByteString
-- Data.Text.Encoding encodeUtf32BE :: Text -> ByteString
-- Data.Text.Lazy.Encoding encodeUtf8 :: Text -> ByteString
-- Data.Text.Lazy.Encoding encodeUtf16LE :: Text -> ByteString
-- Data.Text.Lazy.Encoding encodeUtf16BE :: Text -> ByteString
-- Data.Text.Lazy.Encoding encodeUtf32LE :: Text -> ByteString
-- Data.Text.Lazy.Encoding encodeUtf32BE :: Text -> ByteString
-- -- plus more results not shown, pass --count=20 to see more
