-- FIXME REMOVE
module Fission.CLI.Command.App.Init.Types
  ( Options          (..)
  , OptionalFilePath (..)
  ) where

import           Fission.Prelude

-- | Arguments, flags & switches for the `app init` command
data Options = Options
  { appDir   :: !FilePath
  , buildDir :: !(Maybe FilePath)
  }

newtype OptionalFilePath = OptionalFilePath (Maybe FilePath)

instance IsString OptionalFilePath where
  fromString = OptionalFilePath . \case
    ""   -> Nothing
    path -> Just path
