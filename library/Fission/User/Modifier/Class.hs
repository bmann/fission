module Fission.User.Modifier.Class
  ( Modifier (..)
  , Errors
  ) where

import           Servant.Server

import qualified Network.IPFS.Add.Error as IPFS.Pin -- Pin uses Add errors
import qualified Network.IPFS.Get.Error as IPFS.Stat -- Stat uses Get errors
import           Network.IPFS.CID.Types

import           Fission.Error
import           Fission.Models
import           Fission.Prelude

import qualified Fission.Key           as Key
import qualified Crypto.PubKey.RSA     as RSA

import           Fission.URL
import           Fission.User.Password as Password


type Errors = OpenUnion
  '[ NotFound User
  
   , NotFound            URL
   , ActionNotAuthorized URL

   , IPFS.Pin.Error
   , IPFS.Stat.Error

   , ServerError
   , InvalidURL
   ]

class Monad m => Modifier m where
  updatePassword ::
       UserId
    -> Password
    -> UTCTime
    -> m (Either Password.FailedDigest Password)

  updatePublicKey ::
       UserId
    -> Key.Public
    -> UTCTime
    -> m (Either Errors Key.Public)

  addExchangeKey ::
       UserId
    -> RSA.PublicKey
    -> UTCTime
    -> m (Either Errors [RSA.PublicKey])

  removeExchangeKey ::
       UserId
    -> RSA.PublicKey
    -> UTCTime
    -> m (Either Errors [RSA.PublicKey])
   
  setData ::
       UserId
    -> CID
    -> UTCTime
    -> m (Either Errors ())
