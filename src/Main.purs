module Main where

import Prelude (Unit, bind, pure, unit, ($))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Maybe (Maybe(..))
import Node.Process (lookupEnv, PROCESS)

import Slack as S

echoHandler :: forall e. S.MessageHandler e
echoHandler m = pure $ [S.echo m]

myHandlers :: forall e. Array (S.MessageHandler e)
myHandlers = [echoHandler, echoHandler, echoHandler]

main :: Eff (S.SlackEffects (process :: PROCESS, console :: CONSOLE)) Unit
main = do
  token <- lookupEnv "SLACK_API_TOKEN" -- Get an API Token from the ENV
  case token of
    Nothing -> log "SLACK_API_TOKEN environment variable must be set!"
    Just t  -> do
      S.runSlackRtm (S.handleMessages myHandlers) {token: t} S.rtmHandler
      pure unit
