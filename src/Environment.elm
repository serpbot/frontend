module Environment exposing (init, EnvironmentVar)

type Environment
    = Dev
    | Prod

type alias EnvironmentVar =
    { serverUrl: String
    , environment: Environment
    }

devHost: String
devHost =
    "0.0.0.0"

prodHost: String
prodHost =
    "serpbot.co"

-- Init

init: String -> EnvironmentVar
init host =
    if host == devHost  then
        EnvironmentVar "http://0.0.0.0:5000" Dev
    else if host == "127.0.0.1" then
        EnvironmentVar "http://127.0.0.1:5000" Dev
    else
        EnvironmentVar "https://api.serp.bot" Prod
