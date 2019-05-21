{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}
module App
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import qualified Network.Wai as Wai
import qualified Network.Wai.Handler.Warp as Wai
import Servant
import Shelly
import qualified Data.Text as T
import Data.Semigroup ((<>))
import Control.Concurrent (forkIO)

data Run = Run
  { runResult     :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''Run)

type API = "hook" :> Post '[JSON] Run

startApp :: IO ()
startApp = Wai.run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = do liftIO . forkIO . shelly . verbosely $ mkOverlay
            return (Run "OK")

mkOverlay :: Sh ()
mkOverlay = do
  cd "hackage-overlay"
  run_ "git" ["pull"]
  run_ "tool" ["--keys", "../.keys", "s3://hackage.mobilehaskell.org"]
