module Common.Response exposing (..)

import Json.Decode as Decode exposing (Decoder, bool, int, nullable, string)
import Json.Decode.Pipeline exposing (optional, required)

type alias Response =
    { error: String
    , status: String
    , data: Data
    }

type alias Data =
    { token: Maybe String
    , info: Maybe String
    , website: Maybe Website
    , websites: List(Maybe Website)
    , trend: Maybe Trend
    }

type alias Website =
    { domain: String
    , id: String
    , keywords: List(String)
    , numKeywords: Int
    }

type alias Trend =
    { keywords: List(Maybe Keyword)
    , labels: List(String)
    }

type alias Keyword =
    { label: String
    , data: List(Int)
    }

type alias User =
    { token: String
    }

responseDecoder: Decoder Response
responseDecoder =
    Decode.succeed Response
        |> required "error" string
        |> required "status" string
        |> required "data" dataDecoder

dataDecoder: Decoder Data
dataDecoder =
    Decode.succeed Data
        |> optional "token" (Decode.map Just string) Nothing
        |> optional "info" (Decode.map Just string) Nothing
        |> optional "website" (Decode.map Just websiteDecoder) Nothing
        |> optional "websites" (Decode.list (Decode.map Just websiteDecoder)) []
        |> optional "trend" (Decode.map Just trendDecoder) Nothing

websiteDecoder: Decoder Website
websiteDecoder =
    Decode.succeed Website
        |> required "domain" string
        |> required "id" string
        |> required "keywords" (Decode.list string)
        |> required "num_keywords" int

trendDecoder: Decoder Trend
trendDecoder =
    Decode.succeed Trend
        |> required "keywords" (Decode.list (Decode.map Just keywordDecoder))
        |> required "labels" (Decode.list string)

keywordDecoder: Decoder Keyword
keywordDecoder =
    Decode.succeed Keyword
        |> required "label" string
        |> required "data" (Decode.list int)
