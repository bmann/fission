module Fission.CLI.Parser.App.Init
  ( parser
  , parserWithInfo
  ) where

import           Options.Applicative

import           Fission.Prelude

import qualified Fission.CLI.Parser.App.Init.Types as Init

parserWithInfo :: ParserInfo Init.Options
parserWithInfo =
  info parser $ mconcat
    [ fullDesc
    , progDesc "Initialize an existing app"
    ]

parser :: Parser Init.Options
parser = do
  appDir <- strOption $ mconcat
    [ metavar "APP_PATH"
    , help    "The file path to initialize the app in (app config, etc)"

    , value   "."

    , long    "app-dir"
    , short   'a'
    ]

  Init.OptionalFilePath buildDir <- strOption $ mconcat
    [ metavar "BUILD_PATH"
    , help    "The file path of the assets or directory to sync"

    , value   ""

    , long    "build-dir"
    , short   'b'
    ]

  return Init.Options {..}
