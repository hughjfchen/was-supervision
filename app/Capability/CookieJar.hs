-- | This module define a spec of CookieJar capability

module Capability.CookieJar where


import Network.HTTP.Client (CookieJar)

import Capability.CookieJar
import AppM

instance CookieJar AppM where
  getCookiJar = undefined
