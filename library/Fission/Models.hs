{-# OPTIONS_GHC -fno-warn-missing-export-lists #-}

{-# LANGUAGE NoDeriveAnyClass     #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Fission.Models where

import           Database.Persist.Postgresql
import           Database.Persist.TH

import           Data.Aeson.Types
import           Data.Swagger
import           Data.UUID

import           Network.IPFS.CID.Types
import           Network.IPFS.Bytes.Types

import qualified Fission.Internal.UTF8                as UTF8
import           Fission.Prelude

import           Fission.Platform.Heroku.Region.Types
import           Fission.Security

import qualified Fission.Key                          as Key
import qualified Crypto.PubKey.RSA                    as RSA
import           Fission.URL

import           Fission.User.Email.Types
import           Fission.User.Role.Types
import           Fission.User.Username.Types
import           Fission.Challenge.Types

import qualified Fission.AWS.Zone.Types               as AWS

import           Fission.Internal.Orphanage.Bytes     ()
import           Fission.Internal.Orphanage.CID            ()
import           Fission.Internal.Orphanage.UUID           ()
import           Fission.Internal.Orphanage.RSA2048.Public ()

share
  [ mkPersist       sqlSettings
  , mkDeleteCascade sqlSettings
  , mkMigrate       "migrateAll"
  ] [persistLowerCase|
HerokuAddOn
  uuid       UUID         sqltype=uuid
  region     Region Maybe

  insertedAt UTCTime
  modifiedAt UTCTime

  UniqueUUID uuid

  deriving Show Eq

--------------------------------------------------------------------------------

User
  publicKey     Key.Public    Maybe
  exchangeKeys  [RSA.PublicKey]        default=[]

  email         Email         Maybe
  username      Username

  role          Role
  active        Bool
  verified      Bool                 default=false

  dataRoot      CID
  dataRootSize  Bytes

  herokuAddOnId HerokuAddOnId Maybe
  secretDigest  SecretDigest  Maybe

  insertedAt    UTCTime
  modifiedAt    UTCTime

  UniqueUsername  username
  UniquePublicKey publicKey !force
  -- UniqueEmail     email     !force -- FIXME

  deriving Show Eq

--------------------------------------------------------------------------------

UserChallenge
  userId    UserId
  hash      Challenge

  UniqueUserId    userId
  UniqueChallenge hash

  deriving Show Eq

------------
-- Events --
------------

UpdateUserDataRootEvent
  userId          UserId

  newDataRoot     CID
  newDataRootSize Bytes

  insertedAt      UTCTime

  deriving Show Eq

--------------------------------------------------------------------------------

LoosePin
  ownerId    UserId
  cid        CID

  insertedAt UTCTime

  UniqueCidPerUser ownerId cid

  deriving Show Eq

--------------------------------------------------------------------------------

Domain
  domainName DomainName

  ownerId    UserId
  zoneId     AWS.ZoneID

  insertedAt UTCTime
  modifiedAt UTCTime

  Primary      domainName
  UniqueZoneId zoneId

  deriving Show Eq

--------------------------------------------------------------------------------

App
  ownerId     UserId
  cid         CID

  size        Bytes

  insertedAt  UTCTime
  modifiedAt  UTCTime

  deriving Show Eq

------------
-- Events --
------------

CreateAppEvent
  appId       AppId
  ownerId     UserId

  cid         CID
  size        Bytes

  insertedAt  UTCTime

  deriving Show Eq

DestroyAppEvent
  appId      AppId
  insertedAt UTCTime

  deriving Show Eq

SetAppCIDEvent
  appId      AppId

  newCID     CID
  newCIDSize Bytes

  insertedAt UTCTime

  deriving Show Eq

--------------------------------------------------------------------------------

AppDomain
  appId         AppId

  domainName    DomainName
  subdomain     Subdomain Maybe

  isPrimary     Checkmark nullable

  insertedAt    UTCTime

  UniquePrimaryForApp      appId      isPrimary !force
  UniqueSubdomainPerDomain domainName subdomain !force

  deriving Show Eq

------------
-- Events --
------------

AssociateAppDomainEvent
  appId      AppId

  domainName DomainName
  subdomain  Subdomain Maybe

  insertedAt UTCTime

  deriving Show Eq

DissociateAppDomainEvent
  appId      AppId

  domainName DomainName
  subdomain  Subdomain Maybe

  insertedAt UTCTime

  deriving Show Eq
|]

------------
-- UserId --
------------

instance Arbitrary UserId where
  arbitrary = toSqlKey <$> arbitrary

instance Display UserId where
  display = displayShow

instance Digestable UserId where
  digest = digest . UTF8.textShow

instance ToSchema UserId where
  declareNamedSchema _ =
    mempty
      |> type_ ?~ SwaggerInteger
      |> NamedSchema (Just "UserId")
      |> pure

-----------
-- AppId --
-----------

instance Arbitrary AppId where
  arbitrary = toSqlKey <$> arbitrary

instance ToSchema AppId where
  declareNamedSchema _ =
    mempty
      |> type_ ?~ SwaggerInteger
      |> NamedSchema (Just "AppId")
      |> pure

instance ToParamSchema AppId where
  toParamSchema _ = mempty |> type_ ?~ SwaggerString

instance Display AppId where
  display = displayShow

instance ToJSONKey AppId where
  toJSONKey = toJSONKeyText textDisplay
