module Fission.CLI.Parser.App where

import           Options.Applicative

import           Fission.Prelude

import qualified Fission.CLI.Parser.App.Init  as Init
import qualified Fission.CLI.Parser.App.Types as App
import qualified Fission.CLI.Parser.App.Up    as Up

parserWithInfo :: ParserInfo App.Options
parserWithInfo =
  info parser $ mconcat
    [ fullDesc
    , progDesc "App commands"
    ]

parser :: Parser App.Options
parser = hsubparser $ mconcat
  [ command "init" (App.Init <$> Init.parserWithInfo)
  , command "up"   (App.Up   <$> Up.parserWithInfo)
  ]
