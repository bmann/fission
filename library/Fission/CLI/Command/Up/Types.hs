module Fission.CLI.Command.Up.Types (Options(..)) where

import           Fission.Prelude

-- | Arguments, flags & switches for the `up` command
data Options = Options
    { dnsOnly :: Bool
    , path    :: FilePath
    }
    deriving (Show, Eq)
