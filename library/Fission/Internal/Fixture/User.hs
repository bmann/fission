module Fission.Internal.Fixture.User (user) where

import           Network.IPFS.CID.Types
import           Network.IPFS.Bytes.Types

import           Fission.Prelude
import           Fission.Models

import qualified Fission.User.Role.Types as User.Roles

import           Fission.Internal.Fixture.Time
import qualified Fission.Internal.Fixture.Key.Ed25519 as Ed25519
import qualified Fission.Internal.RSA2048.Pair.Types  as RSA2048

user :: User
user = User
  { userEmail    = Just "test@fission.codes"
  , userUsername = "testUser"

  --

  , userRole   = User.Roles.Regular
  , userActive = True
  , userVerified  = False

  --

  , userPublicKey    = Just Ed25519.pk
  , userExchangeKeys = [RSA2048.pk1]
  --

  , userDataRoot     = CID "QmW2WQi7j6c7UgJTarActp7tDNikE4B2qXtFCfLPdsgaTQ"
  , userDataRootSize = Bytes 0

  --

  , userHerokuAddOnId = Nothing
  , userSecretDigest  = Nothing

  --

  , userInsertedAt = agesAgo
  , userModifiedAt = agesAgo
  }

