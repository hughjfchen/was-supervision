{-# LANGUAGE OverloadedStrings #-}
module Main (main) where


import Control.Monad.IO.Class
import Data.Aeson
import Data.Text
import Network.HTTP.Req
import Text.HTML.Parser

postToHttpBin :: IO ()
postToHttpBin = runReq defaultHttpConfig $ do
  let payload = object [ "foo" .= (10 :: Int)
                       , "bar" .= (20 :: Int)
                       ]
  r <- req
    POST
    (https "httpbin.org" /: "post")
    (ReqBodyJson payload)
    jsonResponse
    mempty
  liftIO $ print (responseBody r :: Value)

getLoginPage :: Text -> [Token]
getLoginPage loginResponse = parseTokens loginResponse

loginPage :: Text
loginPage = "<div><h1>Hello World</h1><br/><p class=widget>Example!</p></div>"

-- >>> getLoginPage loginPage
-- [TagOpen "div" [],TagOpen "h1" [],ContentText "Hello World",TagClose "h1",TagSelfClose "br" [],TagOpen "p" [Attr "class" "widget"],ContentText "Example!",TagClose "p",TagClose "div"]

-- >>> postToHttpBin
-- Object (fromList [("origin",String "51.15.42.58"),("args",Object (fromList [])),("json",Object (fromList [("foo",Number 10.0),("bar",Number 20.0)])),("data",String "{\"foo\":10,\"bar\":20}"),("url",String "https://httpbin.org/post"),("headers",Object (fromList [("Content-Type",String "application/json; charset=utf-8"),("Accept",String "application/json"),("Accept-Encoding",String "gzip"),("Host",String "httpbin.org"),("Content-Length",String "19"),("X-Amzn-Trace-Id",String "Root=1-5fcc87cb-49ed05c3212404fd6671d5b6")])),("files",Object (fromList [])),("form",Object (fromList []))])

main :: IO ()
main = postToHttpBin
