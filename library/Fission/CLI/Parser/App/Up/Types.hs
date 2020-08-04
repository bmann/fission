module Fission.CLI.Parser.App.Up.Types where

import           Fission.Prelude

data Options = Options
  { watch      :: !Bool
  , updateDNS  :: !Bool
  , updateData :: !Bool
  , filePath   :: !FilePath
  } deriving (Show, Eq)
