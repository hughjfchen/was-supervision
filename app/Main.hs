{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.IO.Class
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Text.IO as TI
import qualified Data.ByteString as BS

import Network.HTTP.Req

import Text.HTML.Parser
import Text.HTML.Tree

import Options.Applicative
import CmdLine

import Paths_was_supervision (version)
import Data.Version (showVersion)

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
      parsedText = parseTokens $ TE.decodeUtf8 returnText
  liftIO $ TI.putStrLn $ foldr (\atoken allContent -> case atoken of
                            ContentText t -> allContent <> t
                            _ -> allContent <> "just ignore it") "" parsedText

main :: IO ()
main = execParser cmdOptions >>= changeJVMParameters
