-- |

module Fission.CLI.Parser where

import           Options.Applicative

import           Fission.Prelude

cli :: ParserInfo Command
cli = info commands $ mconcat
  [ progDesc "Fission's CLI"
  , footer "Licensed under the AGPL"
  ]

commands :: Parser Command
commands = subparser $ mconcat
  [ command "user" user
  ]

-----------------------------------------------------

user :: ParserInfo Command
user = info (UserCommand <$> userCommands) mempty
    -- progDesc "User/account commands"

userCommands :: Parser UserCmd
userCommands = subparser $ mconcat
  [ command "whoami" whoami
  , command "setup"  whoami
  ]

whoami :: ParserInfo UserCmd
whoami = info (pure WhoAmI) detail
  where
    detail = mconcat
      [ progDesc "Check the current user"
      -- , help "foo bar baz"
      ]


-- FIXME move to a command submodule

data UserCmd = WhoAmI
data Command = UserCommand UserCmd
