module Slack.RTM
  ( messageListen
  , runSlackRtm
  , send
  , sendMany

  , rtmHandler
) where

import Prelude (Unit, ($), bind, pure, unit, (<<<), (>>=), map)
import Control.Monad.Aff (Aff, liftEff', runAff, makeAff, Canceler)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log, CONSOLE)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Reader.Trans (runReaderT, ask)
import Control.Monad.Trans.Class (lift)
import Data.Either (Either(..))
import Data.Traversable (for)

import Slack.Models
import Slack.RTM.Events (eventType, EventType(..))
import Slack.Types (SlackCreds, SlackRtm, EventName, Client)

listen' :: forall e a. Client -> EventType -> Aff e a
listen' c t = makeAff $ _listen c (eventType t)

messageListen :: forall e. SlackRtm e Message
messageListen = do
  client <- ask
  lift $ listen' client MESSAGE

send :: forall e. MessageOut -> SlackRtm e Unit
send (MessageOut c m) = do
  client <- ask
  lift $ liftEff' $ _send client c m
  pure unit

sendMany :: forall e. Array MessageOut -> SlackRtm e Unit
sendMany ms = do
  for ms \m -> do send m
  pure unit

-- | Ensure that we call start before we run any SlackRtm computations
enforceStart :: forall e a. SlackRtm e a -> SlackRtm e a
enforceStart s = start >>= \_ -> s

start :: forall e. SlackRtm e Unit
start = do
  client <- ask
  _ <- lift $ liftEff' $ _start client
  -- | Wait to ensure the connection is opened before anything else can happen
  _ <- lift $ listen' client RTM_CONNECTION_OPENED
  pure unit

runSlackRtmT :: forall e a. SlackRtm e a -> SlackCreds -> Aff e a
runSlackRtmT slack creds = runReaderT slack $ _client creds

runSlackRtm' :: forall e a. SlackRtm e a -> SlackCreds -> (Error -> Eff e Unit) -> (a -> Eff e Unit) -> Eff e (Canceler e)
runSlackRtm' slack creds err success = runAff err success $ runSlackRtmT slack creds

runSlackRtm :: forall e a. SlackRtm e a -> SlackCreds -> (Either Error a -> Eff e Unit) -> Eff e (Canceler e)
runSlackRtm slack creds handle = runSlackRtm' (enforceStart slack) creds (handle <<< Left) (handle <<< Right)

-- | TODO: Do I need this?
rtmHandler :: forall a e. Either Error a -> Eff (console :: CONSOLE | e) Unit
rtmHandler (Left a)  =  log "Error"
rtmHandler (Right a) =  log "Success"

foreign import _client :: SlackCreds -> Client
foreign import _start :: forall e. Client -> Eff e Unit
foreign import _send :: forall e. Client -> SlackId -> MessageText -> Eff e Unit
foreign import _listen :: forall e a. Client
                                -> EventName
                                -> (Error -> Eff e Unit)
                                -> (a -> Eff e Unit)
                                -> Eff e Unit
