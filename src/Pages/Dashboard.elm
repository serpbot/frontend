module Pages.Dashboard exposing (Model, Msg, page)

import Common.CustomHttp as CustomHttp
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Response, Website, responseDecoder)
import Domain.User exposing (User)
import Environment exposing (EnvironmentVar)
import Gen.Route as Route
import Html exposing (Html, a, b, br, button, dd, div, dl, dt, h1, h2, h3, img, li, main_, p, span, text, ul)
import Html.Attributes as Attr exposing (class)
import Http
import Page
import Shared
import Request exposing (Request)
import Storage exposing (Storage)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr exposing (result)
import View exposing (View)

page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.protected.element <|
        \user ->
            { init = init shared user
            , update = update shared user
            , view = view shared user
            , subscriptions = \_ -> Sub.none
            }

-- Init

type Status
    = Failure String
    | Empty
    | Success
    | Loading

type alias Model =
    { websites: List(Maybe Website)
    , status: Status
    , extended: Bool
    }

type Msg
    = FormSentResp (Result Http.Error Response)
    | ClickedAccount

init: Shared.Model -> User -> (Model, Cmd Msg)
init shared user =
    let
        model = Model [] Loading False
    in
    getAllWebsites shared.env user model


-- Update

getAllWebsites: EnvironmentVar -> User -> Model -> (Model, Cmd Msg)
getAllWebsites env user model =
    ( model
    , Http.request
        { url = env.serverUrl ++ "/website"
        , method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
        , body = Http.emptyBody
        , expect = CustomHttp.expectJson FormSentResp responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )

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


update: Shared.Model -> User -> Msg -> Model -> (Model, Cmd Msg)
update shared user msg model =
    case msg of
        FormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | status = Failure resp.error }, Cmd.none)
                    else
                        if (List.length resp.data.websites) == 0 then
                            ( { model | status = Empty }, Cmd.none)
                        else
                            ( { model | websites = resp.data.websites }, Cmd.none)

                Err err ->
                    errorHandler model shared.storage err

        ClickedAccount ->
            if model.extended then
                ({ model | extended = False }, Cmd.none)
            else
                ({ model | extended = True }, Cmd.none)



-- View


view : Shared.Model -> User -> Model -> View Msg
view shared user model =
    { title = "Dashboard | Serpbot"
    , body = [ div
                [ class "flex flex-col h-screen justify-between bg-gray-50"
                ]
                [ viewHeader (Just user) ClickedAccount model.extended
                , viewMain model
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ Attr.class "mb-auto h-10" ]
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
                        [ text "My sites" ]
                    , a
                        [ Attr.href (Route.toHref Route.Website__Add)
                        , Attr.class "inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        ]
                        [ text "+ Add a website" ]
                    ]
                , br [] []
                ,
                if (List.length model.websites) == 0 then
                    viewInfoMessage
                else
                    div [] []
                , ul
                    [ Attr.class "my-6 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3"
                    ]
                    (List.map viewWebsite model.websites)
                ]
            ]
        ]

viewWebsite: Maybe Website -> Html Msg
viewWebsite maybeWebsite =
    case maybeWebsite of
        Just website ->
            div
                [ Attr.class "relative"
                ]
                [ a
                    [ Attr.href (Route.toHref (Route.Website__View__Id_ {id=website.id}))
                    ]
                    [ li
                        [ Attr.class "col-span-1 bg-white dark:bg-gray-800 rounded-lg shadow p-4 group-hover:shadow-lg cursor-pointer"
                        ]
                        [ div
                            [ Attr.class "w-full flex items-center justify-between space-x-4"
                            ]
                            [ div
                                [ Attr.class "pl-8 flex-1 -mt-px w-full"
                                ]
                                [ h3
                                    [ Attr.class "text-gray-900 font-medium text-lg truncate dark:text-gray-100"
                                    , Attr.style "width" "calc(100% - 4rem)"
                                    ]
                                    [ text website.domain ]
                                ]
                            ]
                        , div
                            [ Attr.class "pl-8 mt-2 flex items-center justify-between"
                            ]
                            [ span
                                [ Attr.class "text-gray-600 dark:text-gray-400 text-sm truncate"
                                ]
                                [ span
                                    [ Attr.class "text-gray-800 dark:text-gray-200"
                                    ]
                                    [ text "Keywords: "
                                    , b [] [ text (String.fromInt website.numKeywords) ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                , a
                    [ Attr.class "absolute top-0 right-0 p-4 mt-1"
                    , Attr.href (Route.toHref (Route.Website__Update__Id_ {id=website.id}))
                    ]
                    [ svg
                        [ SvgAttr.class "w-5 h-5 text-gray-600 dark:text-gray-400 transition hover:text-gray-900 dark:hover:text-gray-100"
                        , SvgAttr.fill "currentColor"
                        , SvgAttr.viewBox "0 0 20 20"
                        ]
                        [ path
                            [ SvgAttr.fillRule "evenodd"
                            , SvgAttr.d "M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z"
                            , SvgAttr.clipRule "evenodd"
                            ]
                            []
                        ]
                    ]
                ]

        Nothing ->
            div [] []

viewInfoMessage: Html Msg
viewInfoMessage =
    div
        [ Attr.class "rounded-md bg-blue-50 p-4"
        ]
        [ div
            [ Attr.class "flex"
            ]
            [ div
                [ Attr.class "flex-shrink-0"
                ]
                [
                svg
                    [ SvgAttr.class "h-5 w-5 text-blue-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.class "ml-3 flex-1 md:flex md:justify-between"
                ]
                [ p
                    [ Attr.class "text-sm text-blue-700"
                    ]
                    [ text "You're not monitoring any websites yet. Click on the purple button to start" ]
                ]
            ]
        ]