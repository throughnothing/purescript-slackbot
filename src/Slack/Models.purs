module Slack.Models
  ( AuthResponse
  , Channel
  , ChannelMembers
  , ChannelName
  , ChannelPurpose
  , ChannelTopic
  , Group
  , IM
  , Message
  , MessageOut(..)
  , MessageText
  , MPIM
  , UserProfile
  , User
  , SlackId
  , Team
) where

-- | Models taken from:
-- | https://api.slack.com/types

-- | TODO: Use purescript-foreign for these?
-- | https://github.com/purescript/purescript-foreign

type ChannelName = String
type MessageText = String
type SlackId = String

-- | https://api.slack.com/events/message
type Message =
  { channel :: String
  , user :: String
  , text :: String
  , ts :: Number
}


data MessageOut = MessageOut ChannelName MessageText

type UserProfile =
  { first_name :: String
  , last_name :: String
  , real_name :: String
  , email :: String
  , skype :: String
  , phone :: String
  , image_24 :: String
  , image_32 :: String
  , image_48 :: String
  , image_72 :: String
  , image_192 :: String
  , image_512 :: String
  }

type User =
  { id :: String
  , name :: String
  , deleted :: String
  , color :: String
  , profile :: UserProfile
  , is_admin :: Boolean
  , is_owner :: Boolean
  , is_primary_owner :: Boolean
  , is_restricted :: Boolean
  , is_ultra_restricted :: Boolean
  , has_2fa :: Boolean
  , two_factor_type :: String
  , has_files :: Boolean
  }


type ChannelMembers = Array String
type ChannelTopic =
  { value :: String
  , creator :: String
  , last_set :: Int
  }
type ChannelPurpose = ChannelTopic
type Channel =
  { id :: String
  , name :: String
  -- | Ignoring the is_channel property, as we shouldn't need it
  , created :: Int
  , creator :: String
  , is_archived :: Boolean
  , is_general :: Boolean
  , members :: ChannelMembers
  , topic :: ChannelTopic
  , purpose :: ChannelPurpose
  , is_member :: Boolean
  , last_read :: Number
  , latest :: Message
  , unread_count :: Int
  , unread_count_display :: Int
  }


type Group = Channel


type IM =
  { id :: String
  , user :: String
  , created :: Int
  , is_user_deleted :: Boolean
}

-- | Multi-Party IM
type MPIM =
  { id :: String
  , name :: String
  , is_group :: Boolean
  , created :: Int
  , creator :: String
    , members :: Array User
  , latest :: Message
  , unread_count :: Int
  , unread_count_display :: Int
}

type Team =
  { id :: String
  , name :: String
  , email_domain :: String
  , domain :: String
  , plan :: String
  }

type AuthResponse =
  { self :: { id :: String , name :: String }
  , team :: Team
  , users :: Array User
  , channels :: Array Channel
  , groups :: Array Group
  -- , mpims :: Array MPIM -- Not mpim_aware, apparently
  , ims :: Array IM
  , bots :: Array User
  }
