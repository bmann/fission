module Fission.CLI.Parser.App.Up where

import           Options.Applicative
import qualified RIO.Text                        as Text

import           Fission.Prelude

import qualified Fission.CLI.Parser.App.Up.Types as Up

parserWithInfo :: ParserInfo Up.Options
parserWithInfo =
  info parser $ mconcat
    [ fullDesc
    , progDesc "Upload the working directory"
    ]

parser :: Parser Up.Options
parser = do
  updateData <- switch $ mconcat
    [ long  "data"
    , help  "Upload the data (defaults to true)"
    ]

  updateDNS <- fmap toBoolLenient $ strOption $ mconcat
    [ long  "dns"
    , help  "Update DNS (defaults to true)"
    ]

  watch <- switch $ mconcat
    [ long  "watch"
    , short 'w'
    , help  "Watch for changes & automatically trigger upload"
    ]

  filePath <- strArgument $ mconcat
    [ metavar "PATH"
    , help    "The file path of the assets or directory to sync"
    , value   "./"
    ]

  return Up.Options {..}

  where
    toBoolLenient :: Text -> Bool
    toBoolLenient txt =
      let
        normalized = Text.toLower txt
      in
        if normalized == "f" || normalized == "false" || normalized == "0"
          then False
          else True
