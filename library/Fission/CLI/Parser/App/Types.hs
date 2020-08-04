module Fission.CLI.Parser.App.Types
  (Options (..)) where

import           Fission.Prelude

import qualified Fission.CLI.Parser.App.Init.Types as Init
import qualified Fission.CLI.Parser.App.Up.Types   as Up

data Options
  = Init Init.Options
  | Up   Up.Options
  deriving (Show, Eq)
