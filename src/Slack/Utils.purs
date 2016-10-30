module Slack.Utils
  ( atUser
  , echo
  , handleMessages
) where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Data.Array (concat)
import Data.Traversable (traverse)
import Prelude (Unit, (<>), map, bind, ($), pure, unit)
import Slack.Models (Message, MessageOut(..))
import Slack.RTM (messageListen, sendMany)
import Slack.Types (SlackRtm, MessageHandler)

atUser :: Message -> String
atUser m = "<@" <> m.user <> ">"

-- | MessageHandler that echoes the messages it recieves on the same channel
echo :: Message -> MessageOut
echo m = MessageOut m.channel ((atUser m) <> ": " <> m.text)

handleMessages' :: forall e. Array (MessageHandler e) -> Message -> Eff e (Array MessageOut)
handleMessages' mhs m = map concat (traverse (\f -> f m) mhs)

handleMessages :: forall e. Array (MessageHandler e) -> SlackRtm e Unit
handleMessages a = do
  msg <- messageListen
  msgs <- liftEff $ handleMessages' a msg
  sendMany msgs
  pure unit
