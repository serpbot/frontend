module Domain.User exposing (User, userDecoder, userEncoder)

import Json.Decode as Decode exposing (Decoder, Value, bool, oneOf, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode


type alias User =
    { token: String
    }


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> required "token" string


userEncoder : Maybe User -> Value
userEncoder user =
    case user of
        Just user_ ->
            Encode.object
                [ ( "token", Encode.string user_.token)
                ]
        Nothing ->
            Encode.object []