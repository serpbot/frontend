port module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , resetCaptcha
    , loadhCaptcha
    , getCaptchaResponse
    , messageReceiver
    , loadGraph
    )

import Common.Response exposing (Trend)
import Gen.Route
import Json.Decode as Decode exposing (Decoder, Value, decodeValue, field, int, map, map2, string, value)
import Json.Decode.Pipeline exposing (required)
import Request exposing (Request)
import Storage exposing (Storage)
import Environment exposing (EnvironmentVar)

-- Models

type alias Flags =
    Decode.Value

type alias Flags_ =
    { year: Int
    , storage: Value
    }

type alias Popover =
    { title: String
    , content: String
    , placement: String
    }

type alias Message =
    { action: String
    , id: String
    , key: String
    , popover: Maybe Popover
    }

type alias Model =
    { year: Int
    , storage: Storage
    , message: String
    , env: EnvironmentVar
    }


type Msg
    = Receive String
    | StorageUpdated Storage

-- Ports

port sendMessage: Message -> Cmd msg
port messageReceiver: (String -> msg) -> Sub msg
port loadCaptcha: () -> Cmd msg
port loadJSGraph: (String, Trend) -> Cmd msg

-- Init

flagDecoder: Decoder Flags_
flagDecoder =
    Decode.succeed Flags_
        |> required "year" int
        |> required "storage" value

init : Request -> Flags -> ( Model, Cmd Msg )
init req flags =
    let
        model =
            case decodeValue flagDecoder flags of
                Ok obj ->
                    Model obj.year (Storage.storageFromJson obj.storage) "" (Environment.init req.url.host)
                Err _ ->
                    Model 2022 Storage.init "" (Environment.init req.url.host)
    in
    ( model
    , if model.storage.user /= Nothing && req.route == Gen.Route.Login then
        Request.replaceRoute Gen.Route.Dashboard req
      else if req.route == Gen.Route.Logout then
        Request.replaceRoute Gen.Route.Login req
      else
        Cmd.none
    )

resetCaptcha: () -> Cmd msg
resetCaptcha  _ =
    sendMessage (Message "resetCaptcha" "" "" Nothing)

loadhCaptcha: Cmd msg
loadhCaptcha =
    loadCaptcha ()

loadGraph: String -> Trend -> Cmd msg
loadGraph engine trend =
    loadJSGraph (engine, trend)

getCaptchaResponse: Cmd msg
getCaptchaResponse =
    sendMessage (Message "getCaptchaResponse" "" "" Nothing)

-- Update

update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        Receive message ->
            ( { model | message = message}, Cmd.none )
        StorageUpdated storage ->
            ( { model | storage = storage}
            , if Gen.Route.Login == req.route then
                Request.pushRoute Gen.Route.Dashboard req
              else
                Cmd.none
            )


-- Subscriptions

subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Storage.onChange StorageUpdated