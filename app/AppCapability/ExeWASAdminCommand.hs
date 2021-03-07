-- | This module implements the capability specified within the library src tree
-- for executing WAS admin commands

module AppCapability.ExeWASAdminCommand
( welcome
  , login
  , listServers
  , pickServer
  , updateJvmGenericParameter
  ) where

import Has
import Core.MyHas
import Error
import Core.MyError

import Core.MyCookieJar (MyCookieJar(..), mergeCookieJar)
import Core.ConnectionInfo (ConnectionInfo(..))
import Core.AuthInfo(AuthInfo(..))

import Capability.ExeWASAdminCommand

import AppM
import AppEnv

import Network.HTTP.Req

instance MonadHttp (AppM err env)

instance AuthM AppM where
  welcome = do
    connInfo <- grab @ConnectionInfo
    mycj <- grab @MyCookieJar
    r <- req GET
      (http (ciHost connInfo) /: (toText $ show $ ciPort connInfo) /: "/ibm/console")
      NoReqBody
      bsResponse
      mempty
    flip mergeCookieJar mycj $ responseCookieJar r
  login = do
    connInfo <- grab @ConnectionInfo
    mycj <- grab @MyCookieJar
    authInfo <- grab @AuthInfo
    r <- req POST
      (http (ciHost connInfo) /: (toText $ ciPort connInfo) /: "/ibm/console")
      NoReqBody
      bsResponse
      mempty
    flip mergeCookieJar mycj $ responseCookieJar r

  logout = undefined

instance ServerM AppM where
  listServers = undefined
  pickServer = undefined

instance JVMM AppM where
  updateJvmGenericParameter = undefined

-- >>> :browse Network.HTTP.Req-- (/:) :: Url scheme -> Text -> Url scheme
-- (/~) ::
--   http-api-data-0.4.2:Web.Internal.HttpApiData.ToHttpApiData a =>
--   Url scheme -> a -> Url scheme
-- (=:) ::
--   (QueryParam param,
--    http-api-data-0.4.2:Web.Internal.HttpApiData.ToHttpApiData a) =>
--   Text -> a -> param
-- newtype BsResponse
--   = Network.HTTP.Req.BsResponse (http-client-0.7.3:Network.HTTP.Client.Types.Response
--                                    ByteString)
-- data CONNECT = CONNECT
-- data CanHaveBody = CanHaveBody | NoBody
-- data DELETE = DELETE
-- newtype FormUrlEncodedParam
--   = Network.HTTP.Req.FormUrlEncodedParam [(Text, Maybe Text)]
-- data GET = GET
-- data HEAD = HEAD
-- class HttpBody body where
--   getRequestBody :: body
--                     -> http-client-0.7.3:Network.HTTP.Client.Types.RequestBody
--   getRequestContentType :: body -> Maybe ByteString
--   {-# MINIMAL getRequestBody #-}
-- type family HttpBodyAllowed (allowsBody :: CanHaveBody)
--                             (providesBody :: CanHaveBody)
--             :: Constraint where
--     HttpBodyAllowed 'NoBody 'NoBody = () :: Constraint
--     HttpBodyAllowed 'CanHaveBody body = () :: Constraint
--     HttpBodyAllowed 'NoBody 'CanHaveBody = (TypeError ...)
-- data HttpConfig
--   = HttpConfig {httpConfigProxy :: Maybe
--                                      http-client-0.7.3:Network.HTTP.Client.Types.Proxy,
--                 httpConfigRedirectCount :: Int,
--                 httpConfigAltManager :: Maybe
--                                           http-client-0.7.3:Network.HTTP.Client.Types.Manager,
--                 httpConfigCheckResponse :: forall b.
--                                            http-client-0.7.3:Network.HTTP.Client.Types.Request
--                                            -> http-client-0.7.3:Network.HTTP.Client.Types.Response b
--                                            -> ByteString
--                                            -> Maybe
--                                                 http-client-0.7.3:Network.HTTP.Client.Types.HttpExceptionContent,
--                 httpConfigRetryPolicy :: retry-0.8.1.2:Control.Retry.RetryPolicyM
--                                            IO,
--                 httpConfigRetryJudge :: forall b.
--                                         retry-0.8.1.2:Control.Retry.RetryStatus
--                                         -> http-client-0.7.3:Network.HTTP.Client.Types.Response b
--                                         -> Bool,
--                 httpConfigRetryJudgeException :: retry-0.8.1.2:Control.Retry.RetryStatus
--                                                  -> SomeException -> Bool,
--                 httpConfigBodyPreviewLength :: forall a. Num a => a}
-- data HttpException
--   = VanillaHttpException http-client-0.7.3:Network.HTTP.Client.Types.HttpException
--   | JsonHttpException String
-- class HttpMethod a where
--   type family AllowsBody a :: CanHaveBody
--   httpMethodName :: Proxy a -> ByteString
--   {-# MINIMAL httpMethodName #-}
-- class HttpResponse response where
--   type family HttpResponseBody response :: *
--   toVanillaResponse :: response
--                        -> http-client-0.7.3:Network.HTTP.Client.Types.Response
--                             (HttpResponseBody response)
--   getHttpResponse :: http-client-0.7.3:Network.HTTP.Client.Types.Response
--                        http-client-0.7.3:Network.HTTP.Client.Types.BodyReader
--                      -> IO response
--   acceptHeader :: Proxy response -> Maybe ByteString
--   {-# MINIMAL toVanillaResponse, getHttpResponse #-}
-- newtype IgnoreResponse
--   = Network.HTTP.Req.IgnoreResponse (http-client-0.7.3:Network.HTTP.Client.Types.Response
--                                        ())
-- newtype JsonResponse a
--   = Network.HTTP.Req.JsonResponse (http-client-0.7.3:Network.HTTP.Client.Types.Response
--                                      a)
-- newtype LbsResponse
--   = Network.HTTP.Req.LbsResponse (http-client-0.7.3:Network.HTTP.Client.Types.Response
--                                     bytestring-0.10.10.1:Data.ByteString.Lazy.Internal.ByteString)
-- class MonadIO m => MonadHttp (m :: * -> *) where
--   handleHttpException :: HttpException -> m a
--   getHttpConfig :: m HttpConfig
--   {-# MINIMAL handleHttpException #-}
-- data NoReqBody = NoReqBody
-- data OPTIONS = OPTIONS
-- type role Network.HTTP.Req.Option phantom
-- data Network.HTTP.Req.Option (scheme :: Scheme)
--   = Network.HTTP.Req.Option (Endo
--                                (http-types-0.12.3:Network.HTTP.Types.URI.QueryText,
--                                 http-client-0.7.3:Network.HTTP.Client.Types.Request))
--                             (Maybe
--                                (http-client-0.7.3:Network.HTTP.Client.Types.Request
--                                 -> IO http-client-0.7.3:Network.HTTP.Client.Types.Request))
-- data PATCH = PATCH
-- data POST = POST
-- data PUT = PUT
-- type family ProvidesBody body :: CanHaveBody where
--     ProvidesBody NoReqBody = 'NoBody
--     ProvidesBody body = 'CanHaveBody
-- class QueryParam param where
--   queryParam :: http-api-data-0.4.2:Web.Internal.HttpApiData.ToHttpApiData
--                   a =>
--                 Text -> Maybe a -> param
--   {-# MINIMAL queryParam #-}
-- type role Req nominal
-- newtype Req a = Network.HTTP.Req.Req (ReaderT HttpConfig IO a)
-- newtype ReqBodyBs = ReqBodyBs ByteString
-- newtype ReqBodyFile = ReqBodyFile FilePath
-- newtype ReqBodyJson a = ReqBodyJson a
-- newtype ReqBodyLbs
--   = ReqBodyLbs bytestring-0.10.10.1:Data.ByteString.Lazy.Internal.ByteString
-- data ReqBodyMultipart
--   = Network.HTTP.Req.ReqBodyMultipart ByteString
--                                       http-client-0.7.3:Network.HTTP.Client.Types.RequestBody
-- newtype ReqBodyUrlEnc = ReqBodyUrlEnc FormUrlEncodedParam
-- data Scheme = Http | Https
-- data TRACE = TRACE
-- type role Url nominal
-- data Url (scheme :: Scheme)
--   = Network.HTTP.Req.Url Scheme (NonEmpty Text)
-- attachHeader ::
--   ByteString
--   -> ByteString
--   -> http-client-0.7.3:Network.HTTP.Client.Types.Request
--   -> http-client-0.7.3:Network.HTTP.Client.Types.Request
-- basicAuth ::
--   ByteString -> ByteString -> Network.HTTP.Req.Option 'Https
-- basicAuthUnsafe ::
--   ByteString -> ByteString -> Network.HTTP.Req.Option scheme
-- basicProxyAuth ::
--   ByteString -> ByteString -> Network.HTTP.Req.Option scheme
-- bsResponse :: Proxy BsResponse
-- cookieJar ::
--   http-client-0.7.3:Network.HTTP.Client.Types.CookieJar
--   -> Network.HTTP.Req.Option scheme
-- customAuth ::
--   (http-client-0.7.3:Network.HTTP.Client.Types.Request
--    -> IO http-client-0.7.3:Network.HTTP.Client.Types.Request)
--   -> Network.HTTP.Req.Option scheme
-- decompress ::
--   (ByteString -> Bool) -> Network.HTTP.Req.Option scheme
-- defaultHttpConfig :: HttpConfig
-- header ::
--   ByteString -> ByteString -> Network.HTTP.Req.Option scheme
-- http :: Text -> Url 'Http
-- httpVersion :: Int -> Int -> Network.HTTP.Req.Option scheme
-- https :: Text -> Url 'Https
-- ignoreResponse :: Proxy IgnoreResponse
-- jsonResponse :: Proxy (JsonResponse a)
-- lbsResponse :: Proxy LbsResponse
-- oAuth1 ::
--   ByteString
--   -> ByteString
--   -> ByteString
--   -> ByteString
--   -> Network.HTTP.Req.Option scheme
-- oAuth2Bearer :: ByteString -> Network.HTTP.Req.Option 'Https
-- oAuth2Token :: ByteString -> Network.HTTP.Req.Option 'Https
-- port :: Int -> Network.HTTP.Req.Option scheme
-- queryFlag :: QueryParam param => Text -> param
-- renderUrl :: Url scheme -> Text
-- req ::
--   (MonadHttp m, HttpMethod method, HttpBody body,
--    HttpResponse response,
--    HttpBodyAllowed (AllowsBody method) (ProvidesBody body)) =>
--   method
--   -> Url scheme
--   -> body
--   -> Proxy response
--   -> Network.HTTP.Req.Option scheme
--   -> m response
-- req' ::
--   (MonadHttp m, HttpMethod method, HttpBody body,
--    HttpBodyAllowed (AllowsBody method) (ProvidesBody body)) =>
--   method
--   -> Url scheme
--   -> body
--   -> Network.HTTP.Req.Option scheme
--   -> (http-client-0.7.3:Network.HTTP.Client.Types.Request
--       -> http-client-0.7.3:Network.HTTP.Client.Types.Manager -> m a)
--   -> m a
-- reqBodyMultipart ::
--   MonadIO m =>
--   [Network.HTTP.Client.MultipartFormData.Part] -> m ReqBodyMultipart
-- reqBr ::
--   (MonadHttp m, HttpMethod method, HttpBody body,
--    HttpBodyAllowed (AllowsBody method) (ProvidesBody body)) =>
--   method
--   -> Url scheme
--   -> body
--   -> Network.HTTP.Req.Option scheme
--   -> (http-client-0.7.3:Network.HTTP.Client.Types.Response
--         http-client-0.7.3:Network.HTTP.Client.Types.BodyReader
--       -> IO a)
--   -> m a
-- reqCb ::
--   (MonadHttp m, HttpMethod method, HttpBody body,
--    HttpResponse response,
--    HttpBodyAllowed (AllowsBody method) (ProvidesBody body)) =>
--   method
--   -> Url scheme
--   -> body
--   -> Proxy response
--   -> Network.HTTP.Req.Option scheme
--   -> (http-client-0.7.3:Network.HTTP.Client.Types.Request
--       -> m http-client-0.7.3:Network.HTTP.Client.Types.Request)
--   -> m response
-- responseBody ::
--   HttpResponse response => response -> HttpResponseBody response
-- responseCookieJar ::
--   HttpResponse response =>
--   response -> http-client-0.7.3:Network.HTTP.Client.Types.CookieJar
-- responseHeader ::
--   HttpResponse response => response -> ByteString -> Maybe ByteString
-- responseStatusCode :: HttpResponse response => response -> Int
-- responseStatusMessage ::
--   HttpResponse response => response -> ByteString
-- responseTimeout :: Int -> Network.HTTP.Req.Option scheme
-- runReq :: MonadIO m => HttpConfig -> Req a -> m a
-- urlQ ::
--   template-haskell-2.15.0.0:Language.Haskell.TH.Quote.QuasiQuoter
-- useHttpURI ::
--   modern-uri-0.3.3.0:Text.URI.Types.URI
--   -> Maybe (Url 'Http, Network.HTTP.Req.Option scheme)
-- useHttpsURI ::
--   modern-uri-0.3.3.0:Text.URI.Types.URI
--   -> Maybe (Url 'Https, Network.HTTP.Req.Option scheme)
-- useURI ::
--   modern-uri-0.3.3.0:Text.URI.Types.URI
--   -> Maybe
--        (Either
--           (Url 'Http, Network.HTTP.Req.Option scheme0)
--           (Url 'Https, Network.HTTP.Req.Option scheme1))
-- withReqManager ::
--   MonadIO m =>
--   (http-client-0.7.3:Network.HTTP.Client.Types.Manager -> m a) -> m a
