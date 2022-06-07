module Domain.User exposing (User, userDecoder, userEncoder)

import Json.Decode as Decode exposing (Decoder, Value, bool, oneOf, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


type alias User =
    { token: String
    , username: String
    , notifications: Bool
    }


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "token" string
        |> required "username" string
        |> required "notifications" bool


userEncoder : Maybe User -> Value
userEncoder user =
    case user of
        Just user_ ->
            Encode.object
                [ ( "token", Encode.string user_.token)
                , ( "username", Encode.string user_.username)
                , ( "notifications", Encode.bool user_.notifications)
                ]
        Nothing ->
            Encode.object []