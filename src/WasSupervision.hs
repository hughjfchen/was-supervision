{- |
Copyright: (c) 2020 Hugh JF Chen
SPDX-License-Identifier: MIT
Maintainer: Hugh JF Chen <hugh.jf.chen@gmail.com>

Take the provision of a WebSphere cell.
-}
{-# LANGUAGE OverloadedStrings #-}

module WasSupervision
       ( changeJVMParameters
       ) where

import Control.Monad.IO.Class
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Text.IO as TI
import qualified Data.ByteString as BS

import Network.HTTP.Req

import Text.HTML.Parser
import Text.HTML.Tree

import Types (CmdOptions(..))

changeJVMParameters :: CmdOptions -> IO ()
changeJVMParameters opts = runReq defaultHttpConfig $ do
  firstPage <- req
    GET
    -- (http (cmdHost opts) /: "ibm" /: "console")
    (http (cmdHost opts) )
    NoReqBody
    bsResponse
    $ port (cmdPort opts)
  let firstCookieJar = responseCookieJar firstPage
      returnText = responseBody firstPage
      parsedForest = tokensToForest $ parseTokens $ TE.decodeUtf8 returnText
  liftIO $ loginForm parsedForest
  where loginForm (Left e) = print e
        loginForm (Right f) = print f
