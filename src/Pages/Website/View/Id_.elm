module Pages.Website.View.Id_ exposing (Model, Msg, page)

import Common.CustomHttp as CustomHttp
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Response, Website, responseDecoder)
import Dict
import Domain.User exposing (User)
import Environment exposing (EnvironmentVar)
import Gen.Params.Website.View.Id_ exposing (Params)
import Gen.Route as Route
import Html exposing (Html, a, br, button, canvas, div, h2, h3, img, li, main_, span, text, ul)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onClick)
import Http
import Page
import Request
import Shared exposing (loadGraph)
import Storage exposing (Storage)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.element <|
        \user ->
            { init = init req shared user
            , update = update req shared user
            , view = view shared req user
            , subscriptions = \_ -> Sub.none
            }

-- Init

type Status
    = Failure String
    | Loading

type alias Model =
    { status: Status
    , extended: Bool
    , websites: List(Maybe Website)
    , websiteDropdown: Bool
    , filterDropdown: Bool
    , domain: String
    , filter: String
    , mobile: Bool
    }

type Msg
    = GoogleFormSentResp (Result Http.Error Response)
    | BingFormSentResp (Result Http.Error Response)
    | AllWebsitesFormSentResp (Result Http.Error Response)
    | WebsiteFormSentResp (Result Http.Error Response)
    | ClickedAccount
    | ClickedMobileMenu
    | ClickedWebsiteDropdown
    | ClickedFilterDropdown
    | ClickedFilter7d
    | ClickedFilter30d
    | ClickedFilterAll

init: Request.With Params -> Shared.Model -> User -> (Model, Cmd Msg)
init req shared user=
    let
        model = Model Loading False [] False False "" "30d" False
    in
    ( model
    , Cmd.batch [ getTrendGoogle req.params.id "30d" shared.env user
                , getTrendBing req.params.id "30d" shared.env user
                , getAllWebsites shared.env user
                , getWebsite shared.env user req.params.id
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

getWebsite: EnvironmentVar -> User -> String -> Cmd Msg
getWebsite env user id =
    Http.request
        { url = env.serverUrl ++ "/website/" ++ id
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson WebsiteFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

getAllWebsites: EnvironmentVar -> User -> Cmd Msg
getAllWebsites env user =
    Http.request
        { url = env.serverUrl ++ "/website"
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson AllWebsitesFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

getTrendGoogle: String -> String -> EnvironmentVar -> User -> Cmd Msg
getTrendGoogle id period env user =
    Http.request
        { url = env.serverUrl ++ "/trend/" ++ id ++ "/google?period=" ++ period
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson GoogleFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

getTrendBing: String -> String -> EnvironmentVar -> User -> Cmd Msg
getTrendBing id period env user =
    Http.request
        { url = env.serverUrl ++ "/trend/" ++ id ++ "/bing?period=" ++ period
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson BingFormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

update: Request.With Params -> Shared.Model -> User -> Msg -> Model -> (Model, Cmd Msg)
update req shared user msg model =
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

        ClickedAccount ->
            if model.extended then
                ({ model | extended = False }, Cmd.none)
            else
                ({ model | extended = True }, Cmd.none)


        ClickedMobileMenu ->
            if model.mobile then
                ({ model | mobile = False }, Cmd.none)
            else
                ({ model | mobile = True }, Cmd.none)

        ClickedWebsiteDropdown ->
            if model.websiteDropdown then
                ({ model | websiteDropdown = False }, Cmd.none)
            else
                ({ model | websiteDropdown = True }, Cmd.none)

        ClickedFilterDropdown ->
            if model.filterDropdown then
                ({ model | filterDropdown = False }, Cmd.none)
            else
                ({ model | filterDropdown = True }, Cmd.none)

        AllWebsitesFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | status = Failure resp.error }, Cmd.none)
                    else
                        ( { model | websites = resp.data.websites }, Cmd.none)

                Err err ->
                    errorHandler model shared.storage err

        WebsiteFormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | status = Failure resp.error }, Cmd.none)
                    else
                        case resp.data.website of
                            Just website ->
                                ( { model | domain = website.domain }, Cmd.none)
                            Nothing ->
                                ( { model | status = Failure "Internal server error" }, Cmd.none)

                Err err ->
                    errorHandler model shared.storage err

        ClickedFilter7d ->
            ( { model | filter = "7d", filterDropdown = False }
            , Cmd.batch [ getTrendBing req.params.id "7d" shared.env user
                              , getTrendGoogle req.params.id "7d" shared.env user
                              ]
            )

        ClickedFilter30d ->
            ( { model | filter = "30d", filterDropdown = False }
            , Cmd.batch [ getTrendBing req.params.id "30d" shared.env user
                              , getTrendGoogle req.params.id "30d" shared.env user
                              ]
            )

        ClickedFilterAll ->
            ( { model | filter = "all", filterDropdown = False }
            , Cmd.batch [ getTrendBing req.params.id "all" shared.env user
                              , getTrendGoogle req.params.id "all" shared.env user
                              ]
            )






-- View

view : Shared.Model -> Request.With Params -> User -> Model -> View Msg
view shared req user model =
    { title = "View Trends | Serpbot"
    , body = [ div
                [ class "bg-gray-50"
                ]
                [ viewHeader (Just user) ClickedAccount model.extended ClickedMobileMenu model.mobile
                , viewMain model req.params.id
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Model -> String -> Html Msg
viewMain model id =
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
                , viewFilter model id
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

viewFilter: Model -> String -> Html Msg
viewFilter model id =
    div
        [ Attr.class "relative top-0 sm:py-3 py-2 z-10 "
        ]
        [ div
            [ Attr.class "items-center w-full flex"
            ]
            [ div
                [ Attr.class "flex items-center w-full"
                ]
                [ div
                    [ Attr.class "relative inline-block text-left mr-2 sm:mr-4"
                    ]
                    [ button
                        [ Attr.class "inline-flex items-center md:text-lg w-full rounded-md py-2 leading-5 font-bold text-gray-700 dark:text-gray-300 focus:outline-none transition ease-in-out duration-150 hover:text-gray-500 dark:hover:text-gray-200 focus:border-blue-300 focus:ring "
                        , onClick ClickedWebsiteDropdown
                        ]
                        [ span
                            [ Attr.class "hidden sm:inline-block"
                            ]
                            [ text model.domain ]
                        , svg
                            [ SvgAttr.class "-mr-1 ml-1 md:ml-2 h-5 w-5"
                            , SvgAttr.viewBox "0 0 20 20"
                            , SvgAttr.fill "currentColor"
                            ]
                            [ path
                                [ SvgAttr.fillRule "evenodd"
                                , SvgAttr.d "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                , SvgAttr.clipRule "evenodd"
                                ]
                                []
                            ]
                        ]
                    , (if model.websiteDropdown then
                        viewWebsiteMenu model.websites
                       else
                        div [] []
                    )
                    ]
                , div
                    [ Attr.id "filters"
                    , Attr.class "flex flex-wrap"
                    ]
                    []
                ]
            , div
                [ Attr.class "flex ml-auto pl-2"
                ]
                [ div
                    [ Attr.class "w-20 sm:w-36 md:w-48 md:relative"
                    ]
                    [ div
                        [ Attr.class "flex items-center justify-between rounded bg-white dark:bg-gray-800 shadow px-2 md:px-3 py-2 leading-tight cursor-pointer text-xs md:text-sm text-gray-800 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-900"
                        , Attr.tabindex 0
                        , Attr.attribute "role" "button"
                        , Attr.attribute "aria-haspopup" "true"
                        , Attr.attribute "aria-expanded" "false"
                        , Attr.attribute "aria-controls" "datemenu"
                        , onClick ClickedFilterDropdown
                        ]
                        [ span
                            [ Attr.class "truncate mr-1 md:mr-2"
                            ]
                            [ span
                                [ Attr.class "font-medium"
                                ]
                                [ (if model.filter == "30d" then
                                    text "Last 30 days"
                                   else if model.filter == "7d" then
                                    text "Last 7 days"
                                   else
                                    text "All Time"

                                  )
                                ]
                            ]
                        , svg
                            [ SvgAttr.viewBox "0 0 20 20"
                            , SvgAttr.fill "currentColor"
                            , SvgAttr.class "hidden sm:inline-block h-4 w-4 md:h-5 md:w-5 text-gray-500"
                            ]
                            [ path
                                [ SvgAttr.fillRule "evenodd"
                                , SvgAttr.d "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                , SvgAttr.clipRule "evenodd"
                                ]
                                []
                            ]
                        ]
                    , (if model.filterDropdown then
                        viewDateMenu id model
                       else
                        div [] []
                        )
                    ]
                ]
            ]
        ]

viewDateMenu: String -> Model -> Html Msg
viewDateMenu id model =
    div
        [ Attr.id "datemenu"
        , Attr.class "absolute w-full left-0 right-0 md:w-56 md:absolute md:top-auto md:left-auto md:right-0 mt-2 origin-top-right z-10"
        ]
        [ div
            [ Attr.class "rounded-md shadow-lg  bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5 font-medium text-gray-800 dark:text-gray-200 date-options"
            ]
            [ div
                [ Attr.class "py-1 border-b border-gray-200 dark:border-gray-500 date-option-group"
                ]
                [ a
                    [ (if model.filter == "7d" then
                        Attr.class "font-bold px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                      else
                        Attr.class "px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                    )
                    , Attr.href "#"
                    , onClick ClickedFilter7d
                    ]
                    [ text "Last 7 days", span
                        [ Attr.class "font-normal"
                        ]
                        [ text "W" ]
                    ]
                , a
                    [ (if model.filter == "30d" then
                        Attr.class "font-bold px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                      else
                        Attr.class "px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                      )
                    , Attr.href "#"
                    , onClick ClickedFilter30d
                    ]
                    [ text "Last 30 days", span
                        [ Attr.class "font-normal"
                        ]
                        [ text "T" ]
                    ]
                ]
            , div
                [ Attr.class "py-1 date-option-group"
                ]
                [ a
                    [ (if model.filter == "all" then
                        Attr.class "font-bold px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                      else
                        Attr.class "px-4 py-2 text-sm leading-tight hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-gray-900 dark:hover:text-gray-100 flex items-center justify-between"
                    )
                    , Attr.href "#"
                    , onClick ClickedFilterAll
                    ]
                    [ text "All time", span
                        [ Attr.class "font-normal"
                        ]
                        [ text "A" ]
                    ]
                ]
            ]
        ]

viewWebsiteMenu: List(Maybe Website) -> Html Msg
viewWebsiteMenu websites =
    div
        [ Attr.class ""
        ]
        [ div
            [ Attr.class "origin-top-left absolute left-0 mt-2 w-64 rounded-md shadow-lg"
            ]
            [ div
                [ Attr.class "rounded-md bg-white dark:bg-gray-800 ring-1 ring-black ring-opacity-5"
                ]
                [ div
                    [ Attr.class "border-t border-gray-200 dark:border-gray-500"
                    ]
                    []
                , div
                    [ Attr.class "py-1"
                    ]
                    (List.map viewWebsiteDomain websites)
                , div
                    [ Attr.class "border-t border-gray-200 dark:border-gray-500"
                    ]
                    []
                ]
            ]
        ]

viewWebsiteDomain: Maybe Website -> Html Msg
viewWebsiteDomain website =
    case website of
        Just w ->
            a
                [ Attr.href (Route.toHref (Route.Website__View__Id_ {id=w.id}))
                , Attr.class "flex items-center justify-between truncate px-4 py-2 md:text-sm leading-5 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900 hover:text-gray-900 dark:hover:text-gray-100 focus:outline-none focus:bg-gray-100 dark:focus:bg-gray-900 focus:text-gray-900 dark:focus:text-gray-100"
                ]
                [ span []
                    [ span
                        [ Attr.class "truncate inline-block align-middle max-w-3xs pr-2"
                        ]
                        [ text w.domain ]
                    ]
                ]
        Nothing ->
            a [] []
