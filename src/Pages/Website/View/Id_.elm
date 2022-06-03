module Pages.Website.View.Id_ exposing (Model, Msg, page)

import Common.CustomHttp as CustomHttp
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Response, responseDecoder)
import Domain.User exposing (User)
import Environment exposing (EnvironmentVar)
import Gen.Params.Website.View.Id_ exposing (Params)
import Html exposing (Html, a, br, canvas, div, h2, h3, li, main_, text, ul)
import Html.Attributes as Attr exposing (class)
import Http
import Page
import Request
import Shared exposing (loadGraph)
import Storage exposing (Storage)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element <|
        \user ->
            { init = init req shared user
            , update = update shared
            , view = view shared user
            , subscriptions = \_ -> Sub.none
            }

-- Init

type Status
    = Failure String
    | Loading

type alias Model =
    { status: Status
    }

type Msg
    = GoogleFormSentResp (Result Http.Error Response)
    | BingFormSentResp (Result Http.Error Response)

init: Request.With Params -> Shared.Model -> User -> (Model, Cmd Msg)
init req shared user=
    let
        model = Model Loading
    in
    ( model
    , Cmd.batch [ getTrendGoogle req.params.id shared.env user
                , getTrendBing req.params.id shared.env user
                ]
    )

-- Update

errorHandler: Model -> Storage -> Http.Error -> (Model, Cmd Msg)
errorHandler model storage err =
    case err of
        Http.BadStatus code ->
            if code == 401 then
                ( { model | status = Failure "Login session expired" }, Storage.signOut storage)
            else
                ( { model | status = Failure "Unable to fetch user details, please try again later" }, Cmd.none)
        _ ->
            ( { model | status = Failure "Unable to fetch user details, please try again later" }, Cmd.none)

getTrendGoogle: String -> EnvironmentVar -> User -> Cmd Msg
getTrendGoogle id env user =
    Http.request
        { url = env.serverUrl ++ "/trend/" ++ id ++ "/google"
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson GoogleFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

getTrendBing: String -> EnvironmentVar -> User -> Cmd Msg
getTrendBing id env user =
    Http.request
        { url = env.serverUrl ++ "/trend/" ++ id ++ "/bing"
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson BingFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

update: Shared.Model -> Msg -> Model -> (Model, Cmd Msg)
update shared msg model =
    case msg of
        GoogleFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | status = Failure resp.error }, Cmd.none)
                    else
                        case resp.data.trend of
                            Just trend ->
                                (model, loadGraph "google" trend)

                            Nothing ->
                                ( { model | status = Failure resp.error }, Cmd.none)
                Err err ->
                    errorHandler model shared.storage err

        BingFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | status = Failure resp.error }, Cmd.none)
                    else
                        case resp.data.trend of
                            Just trend ->
                                (model, loadGraph "bing" trend)

                            Nothing ->
                                ( { model | status = Failure resp.error }, Cmd.none)
                Err err ->
                    errorHandler model shared.storage err




-- View

view : Shared.Model -> User -> Model -> View Msg
view shared user model =
    { title = "Serpbot | Add Website"
    , body = [ div
                [ class "bg-gray-50"
                ]
                [ viewHeader (Just user)
                , viewMain model
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ ]
        [ div
            [ Attr.class "max-w-7xl mx-auto sm:px-6 lg:px-8"
            ]
            [ div
                [ Attr.attribute "lass" "container pt-6"
                ]
                [ div
                    [ Attr.class "mt-6 pb-5 border-b border-gray-200 dark:border-gray-500 flex items-center justify-between"
                    ]
                    [ h2
                        [ Attr.class "text-2xl font-bold leading-7 text-gray-900 dark:text-gray-100 sm:text-3xl sm:leading-9 sm:truncate flex-shrink-0"
                        ]
                        [ text "Website Stats" ]
                    ]
                , br [] []
                , ul
                    [ Attr.attribute "role" "list"
                    , Attr.class "space-y-3"
                    ]
                    [ li
                        [ Attr.class "bg-white shadow overflow-hidden rounded-md px-6 py-4"
                        ]
                        [ div [ Attr.class "text-xl" ] [ text "Google" ]
                        , canvas
                            [ Attr.id "google"
                            ]
                            []
                        ]
                    , li
                        [ Attr.class "bg-white shadow overflow-hidden rounded-md px-6 py-4"
                        ]
                        [ div [ Attr.class "text-xl" ] [ text "Bing" ]
                        , canvas
                            [ Attr.id "bing"
                            ]
                            []
                        ]
                    ]
                , br [] []
                ]
            ]
        ]