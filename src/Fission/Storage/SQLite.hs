{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Fission.Storage.SQLite
  ( setupTable
  , connPool
  , makeTable
  ) where

import RIO

import Data.Has
import Data.Pool

import Database.Selda
import Database.Selda.SQLite
import Database.Selda.Backend

import           Fission.Internal.Constraint
import           Fission.Config              as Config
import qualified Fission.Storage.Table       as Table
import qualified Fission.Log                 as Log

setupTable :: MonadRIO cfg m
           => HasLogFunc cfg
           => Has DBPath cfg
           => Table b
           -> TableName
           -> m ()
setupTable tbl tblName = do
  DBPath db <- fromCfg
  logInfo $ "Creating table `" <> displayShow tblName <> "` in DB " <> displayShow db
  liftIO . withSQLite db $ createTable tbl

-- TODO make configurable
connPool :: HasLogFunc cfg => DBPath -> RIO cfg (Pool SeldaConnection)
connPool (DBPath {getDBPath = path}) = do
  logInfo $ "Establishing database connection for " <> displayShow path

  pool <- liftIO $ createPool (sqliteOpen path) seldaClose 4 2 10 -- config these
  logInfo $ "DB pool stats: " <> displayShow pool

  return pool

makeTable :: Table t -> Table.Name t -> IO ()
makeTable tbl tblName = runRIO (mkLogFunc Log.simple) do
  pool <- connPool $ DBPath "ipfs-api.sqlite"
  runRIO (Config.base $ DBPool pool) $ setupTable tbl (Table.name tblName)