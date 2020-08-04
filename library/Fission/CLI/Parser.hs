module Fission.CLI.Parser where

import           Options.Applicative

import           Fission.Prelude

cli :: ParserInfo Options
cli = info ((Named <$> commands) <|> version) $ mconcat
  [ progDesc "Fission's CLI"
  , footer "Visit https://fission.codes for more"
  ]

commands :: Parser Command
commands =
  subparser $ mconcat
    [ command "user"  user
    , command "app"   app   -- FIXME
    , command "files" files -- FIXME
    ]

version :: Parser Options
version = do
  flipped <- switch $ mconcat
    [ long "version"
    , short 'v'
    , help  "Print version"
    ]

  pure $ Version flipped

app = undefined
files = undefined

-----------------------------------------------------

user :: ParserInfo Command
user = info (UserCommand <$> userCommands) $ mconcat
  [ fullDesc
  , progDesc "User/account commands"
  ]

userCommands :: Parser UserCmd
userCommands = subparser $ mconcat
  [ command "whoami" whoami
  , command "setup"  setup
  ]

whoami :: ParserInfo UserCmd
whoami = info (pure WhoAmI) detail
  where
    detail = mconcat
      [ fullDesc
      , progDesc "Check the current user"
      ]

setup :: ParserInfo UserCmd
setup =
  info (pure Setup) $ mconcat
    [ fullDesc
    , progDesc "Set up system"
    ]

data UserCmd
  = Setup
  | WhoAmI
  | Link
  deriving (Show, Eq)

-- data FilesCmd
--   = Init
--   | Push -- watch
--   | Pull -- watch
--   deriving (Show, Eq)

data Options
  = Version Bool
  | Named Command
  deriving (Show, Eq)

data Command
  = UserCommand UserCmd
  deriving (Show, Eq)
