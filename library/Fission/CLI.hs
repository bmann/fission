module Fission.CLI (cli) where

import           Options.Applicative

import qualified RIO.Text                     as Text

import qualified Fission.Internal.CLI.Meta    as Meta
import           Fission.Prelude

import           Fission.CLI.Config.Base
import           Fission.CLI.Config.Connected

-- import           Fission.CLI.Command          as Command
import           Fission.CLI.Display.Error

import qualified Fission.CLI.Command.App.Init as App.Init
import qualified Fission.CLI.Command.Down     as Down
import qualified Fission.CLI.Command.Setup    as Setup
import qualified Fission.CLI.Command.Up       as Up
import qualified Fission.CLI.Command.Watch    as Watch
import qualified Fission.CLI.Command.Whoami   as Whoami

cli :: MonadIO m => BaseConfig -> m ()
cli baseCfg = liftIO do
  Foo <- liftIO $ execParser $ info (subparser $ command "bar"  (info fooParser ( progDesc "Add a file to the repository" ))) mempty
  return ()

data Foo = Foo

fooParser :: Applicative f => f Foo
fooParser = pure Foo

summary :: String
summary = "CLI to interact with Fission services"

detail :: String
detail = "Fission makes developing, deploying, updating, and iterating on web apps quick and easy."

version :: String
version = Text.unpack $ maybe "unknown" identity (Meta.version =<< Meta.package)
