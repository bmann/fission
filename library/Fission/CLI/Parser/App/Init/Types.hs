module Fission.CLI.Parser.App.Init.Types
  ( Options          (..)
  , OptionalFilePath (..)
  ) where

import           Fission.Prelude

-- | Arguments, flags & switches for the `app init` command
data Options = Options
  { appDir   :: !FilePath
  , buildDir :: !(Maybe FilePath)
  } deriving (Show, Eq)

newtype OptionalFilePath
  = OptionalFilePath (Maybe FilePath)
  deriving (Show, Eq)

instance IsString OptionalFilePath where
  fromString = OptionalFilePath . \case
    ""   -> Nothing
    path -> Just path
