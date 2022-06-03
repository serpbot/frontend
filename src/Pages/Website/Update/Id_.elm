module Pages.Website.Update.Id_ exposing (Model, Msg, page)

import Common.Alert exposing (viewAlertFailure, viewAlertSuccess)
import Common.CustomHttp as CustomHttp
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Response, responseDecoder)
import Domain.User exposing (User)
import Environment exposing (EnvironmentVar)
import Gen.Params.Website.Update.Id_ exposing (Params)
import Gen.Route
import Html exposing (Html, a, br, button, dd, div, dl, dt, form, h1, h2, img, input, label, main_, node, option, p, select, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode
import Page
import Shared
import Request exposing (Request)
import Storage exposing (Storage)
import View exposing (View)

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element <|
        \user ->
            { init = init req shared user
            , update = update req user shared
            , view = view shared user
            , subscriptions = \_ -> Sub.none
            }

-- Init

type Status
    = Failure String
    | Success String
    | Loading
    | None

type alias Model =
    { domain: String
    , keywords: List(String)
    , keyword: String
    , status: Status
    }

type Msg
    = ChangeKeyword String
    | ClickedUpdateWebsite
    | ClickedAddKeyword
    | ClickedDeleteWebsite
    | ClickedRemoveKeyword String
    | UpdateFormSentResp (Result Http.Error Response)
    | InitialFormSentResp (Result Http.Error Response)
    | DeleteFormSentResp (Result Http.Error Response)

init: Request.With Params -> Shared.Model -> User -> (Model, Cmd Msg)
init req shared user =
    let
        model = Model "" [] "" Loading
    in
    (getWebsite req.params.id shared.env user model)


-- Update

getWebsite: String -> EnvironmentVar -> User -> Model -> (Model, Cmd Msg)
getWebsite id env user model =
    ( model
    , Http.request
        { url = env.serverUrl ++ "/website/" ++ id
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.jsonBody (encodeModel model)
        , expect = CustomHttp.expectJson InitialFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )

updateWebsite: String -> EnvironmentVar -> User -> Model -> (Model, Cmd Msg)
updateWebsite id env user model =
    ( model
    , Http.request
        { url = env.serverUrl ++ "/website/" ++ id
        , method = "PUT"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.jsonBody (encodeModel model)
        , expect = CustomHttp.expectJson UpdateFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )

deleteWebsite: String -> EnvironmentVar -> User -> Model -> (Model, Cmd Msg)
deleteWebsite id env user model =
    ( model
    , Http.request
        { url = env.serverUrl ++ "/website/" ++ id
        , method = "DELETE"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.jsonBody (encodeModel model)
        , expect = CustomHttp.expectJson UpdateFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )

encodeModel: Model -> Encode.Value
encodeModel model =
    Encode.object
        [ ("keywords", Encode.list Encode.string model.keywords)
        ]

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

update: Request.With Params -> User -> Shared.Model -> Msg -> Model -> (Model, Cmd Msg)
update req user shared msg model =
    case msg of
        ChangeKeyword keyword ->
            ( { model | keyword = keyword }, Cmd.none)

        ClickedUpdateWebsite ->
            if model.domain == "" then
                ( { model | status = Failure "Domain cannot be blank" }, Cmd.none)
            else if (List.isEmpty model.keywords) then
                ( { model | status = Failure "Must add at least one keyword" }, Cmd.none)
            else
                updateWebsite req.params.id shared.env user model

        ClickedDeleteWebsite ->
            deleteWebsite req.params.id shared.env user model

        ClickedAddKeyword ->
            if model.keyword == "" then
                ( { model | status = Failure "Cannot add blank keyword" }, Cmd.none)
            else if not (List.isEmpty (List.filter (\k -> k==model.keyword) model.keywords)) then
                ( { model | status = Failure "Keyword already added" }, Cmd.none)
            else
                ( { model | keywords = (List.append [model.keyword] model.keywords), keyword = "", status = None }, Cmd.none)

        ClickedRemoveKeyword keyword ->
            ( { model | keywords = (List.filter (\k -> k/=keyword) model.keywords) }, Cmd.none)

        UpdateFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | domain = "", keywords = [], keyword = "", status = Failure resp.error }, Cmd.none)
                    else
                        (model, Request.replaceRoute Gen.Route.Dashboard req)
                Err err ->
                    errorHandler model shared.storage err

        InitialFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | domain = "", keywords = [], keyword = "", status = Failure resp.error }, Cmd.none)
                    else
                        case resp.data.website of
                            Just website ->
                                ( { model | domain = website.domain, keywords = website.keywords }, Cmd.none )
                            Nothing ->
                                ( { model | status = Failure "Unable to fetch website details, please try again later" }, Cmd.none)
                Err err ->
                    errorHandler model shared.storage err

        DeleteFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | domain = "", keywords = [], keyword = "", status = Failure resp.error }, Cmd.none)
                    else
                        (model, Request.replaceRoute Gen.Route.Dashboard req)
                Err err ->
                    errorHandler model shared.storage err

-- View


view : Shared.Model -> User -> Model -> View Msg
view shared user model =
    { title = "Serpbot | Update Website"
    , body = [ div
                [ class "flex flex-col h-screen justify-between bg-gray-50"
                ]
                [ viewHeader (Just user)
                , viewMain model
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ Attr.class "mb-auto h-10" ]
        [ div
            [ Attr.class "max-w-lg w-full mx-auto bg-white dark:bg-gray-800 shadow-lg rounded px-8 pt-6 pb-8 mb-4 mt-8"
            ]
            [ input
                [ Attr.name "_csrf_token"
                , Attr.type_ "hidden"
                , Attr.value "EC4FYgoAPGYXQxc8MDY8ATAvBVIrFl1AwdB2_KySs3HWjiWGVEkeNNoy"
                ]
                []
            , h2
                [ Attr.class "text-xl font-black dark:text-gray-100"
                ]
                [ text "Update website details" ]
            ,
            (case model.status of
                Failure error -> viewAlertFailure error
                Success msg -> viewAlertSuccess msg
                _ -> div [] []
            )
            , div
                [ Attr.class "my-6"
                ]
                [ label
                    [ Attr.class "block text-sm font-medium text-gray-700 dark:text-gray-300"
                    , Attr.for "site_domain"
                    ]
                    [ text "Domain" ]
                , p
                    [ Attr.class "text-gray-500 dark:text-gray-400 text-xs mt-1"
                    ]
                    [ text "Just the naked domain or subdomain without 'www'" ]
                , div
                    [ Attr.class "mt-2 flex rounded-md shadow-sm"
                    ]
                    [ span
                        [ Attr.class "inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 dark:border-gray-500 bg-gray-50 dark:bg-gray-850 text-gray-500 dark:text-gray-400 sm:text-sm"
                        ]
                        [ text "https://" ]
                    , input
                        [ Attr.class "bg-gray-50 focus:ring-indigo-500 focus:border-indigo-500 dark:bg-gray-800 flex-1 block w-full px-3 py-2 rounded-none rounded-r-md sm:text-sm border-gray-300 dark:border-gray-500 dark:bg-gray-900 dark:text-gray-300"
                        , Attr.id "site_domain"
                        , Attr.name "site[domain]"
                        , Attr.placeholder "example.com"
                        , Attr.type_ "text"
                        , Attr.disabled True
                        , Attr.value model.domain
                        ]
                        []
                    ]
                ]
            , div []
                [ label
                    [ Attr.for "email"
                    , Attr.class "block text-sm font-medium text-gray-700"
                    ]
                    [ text "Add a keyword" ]
                , div
                    [ Attr.class "mt-1 flex rounded-md shadow-sm"
                    ]
                    [ div
                        [ Attr.class "relative flex items-stretch flex-grow focus-within:z-10"
                        ]
                        [ input
                            [ Attr.id "keyword"
                            , Attr.name "keyword"
                            , Attr.type_ "text"
                            , Attr.class "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                            , Attr.value model.keyword
                            , onInput ChangeKeyword
                            ]
                            []
                        ]
                    , button
                        [ Attr.type_ "button"
                        , Attr.class "-ml-px relative inline-flex items-center space-x-2 px-4 py-2 border border-gray-300 text-sm font-medium rounded-r-md text-gray-700 bg-gray-50 hover:bg-gray-100 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500"
                        , onClick ClickedAddKeyword
                        ]
                        [ span []
                            [ text "Add" ]
                        ]
                    ]
                ]
            , (if not (List.isEmpty model.keywords) then
                viewKeywordsTable model
              else
                div [] []
            )
            , button
                [ Attr.class "button mt-4 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                , onClick ClickedUpdateWebsite
                ]
                [ text "Update website" ]
            , button
                [ Attr.class "float-right button mt-4 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                , onClick ClickedDeleteWebsite
                ]
                [ text "Delete website" ]
            ]
        , br []
            []
        ]

viewKeywordsTable: Model -> Html Msg
viewKeywordsTable model =
    div
        [ Attr.class "-mx-4 mt-10 ring-1 ring-gray-300 sm:-mx-6 md:mx-0 md:rounded-lg"
        ]
        [ table
            [ Attr.class "min-w-full divide-y divide-gray-300"
            ]
            [ thead []
                [ tr []
                    [ th
                        [ Attr.scope "col"
                        , Attr.class "py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6"
                        ]
                        [ text "Keywords" ]
                    , th
                        [ Attr.scope "col"
                        , Attr.class "relative py-3.5 pl-3 pr-4 sm:pr-6"
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Remove" ]
                        ]
                    ]
                ]
            , tbody []
                (List.map viewKeywordRow model.keywords)
            ]
        ]

viewKeywordRow: String -> Html Msg
viewKeywordRow keyword =
    tr []
        [ td
            [ Attr.class "hidden px-3 py-3.5 text-sm text-gray-500 lg:table-cell"
            ]
            [ text keyword ]
        , td
            [ Attr.class "relative py-3.5 pl-3 pr-4 sm:pr-6 text-right text-sm font-medium"
            ]
            [ button
                [ Attr.type_ "button"
                , Attr.class "inline-flex items-center justify-center px-4 py-2 border border-transparent font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:text-sm"
                , onClick (ClickedRemoveKeyword keyword)
                ]
                [ text "Remove" ]
            ]
        ]
