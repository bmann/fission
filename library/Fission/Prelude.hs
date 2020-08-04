-- | A custom @Prelude@-like module for this project
module Fission.Prelude
  ( module Control.Lens
  , module Control.Monad.Logger
  , module Control.Monad.Time
  , module Data.Aeson
  , module Data.Bool
  , module Data.Bifunctor
  , module Data.Has
  , module Data.Maybe
  , module Data.WorldPeace
  , module Fission.Internal.Log
  , module Fission.Internal.Time
  , module Fission.Internal.MonadDB
  , module Flow
  , module RIO
  , module RIO.Process
  , module RIO.Time
  , module Test.QuickCheck
  , module Web.PathPieces
  , Entity (..)
  , headMaybe
  , identity
  , intercalate
  , putText
  , putTextLn
  , textShow
  , displayLazyBS
  , bind
  , ord
  , ok
  , noop
  ) where

import           Control.Lens                                ((%~), (.~), (?~),
                                                              (^?))
import           Control.Monad.Logger                        (LogLevel (..),
                                                              LogSource,
                                                              MonadLogger (..),
                                                              ToLogStr (..),
                                                              logWithoutLoc)
import           Control.Monad.Time

import           Network.IPFS.Internal.Orphanage.Utf8Builder ()

import           Data.Aeson                                  hiding (Options)
import           Data.Bifunctor                              (bimap)
import           Data.Bool
import           Data.Has
import           Data.Maybe
import           Data.WorldPeace

import           Database.Persist                            (Entity (..))

import           Flow

import           RIO.Char                                    (ord)
import           RIO.List                                    (headMaybe,
                                                              intercalate)
import           RIO.Process
import           RIO.Time

import           RIO.Orphans                                 ()

import           RIO                                         hiding (Handler,
                                                              LogLevel (..),
                                                              LogSource, const,
                                                              exp, id, logDebug,
                                                              logDebugS,
                                                              logError,
                                                              logErrorS,
                                                              logInfo, logInfoS,
                                                              logOther,
                                                              logOtherS,
                                                              logWarn, logWarnS,
                                                              timeout, (&),
                                                              (^.))

import           Test.QuickCheck                             hiding
                                                              (Result (..))
import           Test.QuickCheck.Instances                   ()

import           Web.PathPieces

import           Fission.Internal.Log
import           Fission.Internal.MonadDB
import           Fission.Internal.Orphanage.OpenUnion        ()
import           Fission.Internal.Time
import           Fission.Internal.UTF8                       (displayLazyBS,
                                                              putText,
                                                              putTextLn,
                                                              textShow)

identity :: a -> a
identity a = a

bind :: Monad m => (a -> m b) -> m a -> m b
bind = (=<<)

ok :: Either err ()
ok = Right ()

noop :: Applicative f => f ()
noop = pure ()
