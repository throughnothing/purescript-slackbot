module Slack.Types
  ( Client(..)
  , EventName
  , MessageHandler
  , SLACK
  , SlackEffects
  , SlackCreds
  , SlackRtm
  ) where


import Control.Monad.Eff (Eff)
import Control.Monad.Aff (Aff)
import Control.Monad.Reader.Trans (ReaderT)

import Slack.Models (Message, MessageOut)

foreign import data Client :: *
foreign import data SLACK :: !

type EventName = String

type MessageHandler e = Message -> Eff e (Array MessageOut)

type SlackEffects e = (slack :: SLACK | e)

type SlackCreds = { token :: String }

type SlackRtm e a = ReaderT Client (Aff e) a
