port module Storage exposing
    ( Storage
    , storageToJson
    , storageFromJson
    , storageDecoder
    , init
    , onChange
    , signIn
    , signOut
    , changeNotifications
    )

import Domain.User exposing (User, userDecoder, userEncoder)
import Json.Decode as Decode exposing (Decoder, nullable)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode exposing (Value)

-- Model

type alias Storage =
    { user: Maybe User
    }

-- Ports

port save: Decode.Value -> Cmd msg
port load: (Decode.Value -> msg) -> Sub msg


-- Convert to JSON

storageToJson: Storage -> Decode.Value
storageToJson storage =
    Encode.object
        [ ("user", userEncoder storage.user)
        ]

-- Convert from JSON

storageFromJson: Decode.Value -> Storage
storageFromJson json =
    json
        |> Decode.decodeValue storageDecoder
        |> Result.withDefault init


-- Decoders

storageDecoder: Decoder Storage
storageDecoder =
    Decode.succeed Storage
        |> required "user" (nullable userDecoder)


-- Auth

signIn: User -> Storage -> Cmd msg
signIn user storage =
    { storage | user = Just user }
        |> storageToJson
        |> save

signOut: Storage -> Cmd msg
signOut storage =
    { storage | user = Nothing}
        |> storageToJson
        |> save


-- Update storage

changeNotifications: Bool -> Storage -> Cmd msg
changeNotifications notifications storage =
    case storage.user of
        Just user ->
            let
                oldUser = user
                newUser =
                    { oldUser | notifications = notifications }
            in { storage | user = Just newUser }
                |> storageToJson
                |> save

        Nothing ->
            (Cmd.none
            )
-- Init

init: Storage
init =
    { user = Nothing
    }

-- Listen for storage updates

onChange : (Storage -> msg) -> Sub msg
onChange fromStorage =
    load (\json -> storageFromJson json |> fromStorage)