module Pages.NotFound exposing (Model, Msg, page)

import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Gen.Route as Route
import Html exposing (Html, a, br, div, h1, h2, main_, p, span, text)
import Html.Attributes as Attr exposing (class)
import Page
import Shared
import Request exposing (Request)
import Svg exposing (svg)
import Svg.Attributes as SvgAttr
import View exposing (View)

page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.element
        { init = init
        , update = update
        , view = view shared
        , subscriptions = \_ -> Sub.none
        }

-- Init

type alias Model =
    {}

type Msg
    = NoOp

init: (Model, Cmd Msg)
init =
    (Model, Cmd.none)


-- Update

update: Msg -> Model -> (Model, Cmd Msg)
update _ model =
    (model, Cmd.none)

-- View


view : Shared.Model -> Model -> View Msg
view shared _ =
    { title = "Serpbot | Not Found"
    , body = [ div
                [ class "flex flex-col h-screen justify-between bg-gray-50"
                ]
                [ viewHeader shared.storage.user
                , viewMain
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Html Msg
viewMain =
    div
        [ Attr.class "max-w-max mx-auto"
        ]
        [ main_
            [ Attr.class "sm:flex"
            ]
            [ p
                [ Attr.class "text-4xl font-extrabold text-indigo-600 sm:text-5xl"
                ]
                [ text "404" ]
            , div
                [ Attr.class "sm:ml-6"
                ]
                [ div
                    [ Attr.class "sm:border-l sm:border-gray-200 sm:pl-6"
                    ]
                    [ h1
                        [ Attr.class "text-4xl font-extrabold text-gray-900 tracking-tight sm:text-5xl"
                        ]
                        [ text "Page not found" ]
                    , p
                        [ Attr.class "mt-1 text-base text-gray-500"
                        ]
                        [ text "Please check the URL in the address bar and try again." ]
                    ]
                , div
                    [ Attr.class "mt-10 flex space-x-3 sm:border-l sm:border-transparent sm:pl-6"
                    ]
                    [ a
                        [ Attr.href (Route.toHref Route.Home_)
                        , Attr.class "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        ]
                        [ text "Go back home" ]
                    , a
                        [ Attr.href "mailto:support@serp.bot"
                        , Attr.class "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-indigo-700 bg-indigo-100 hover:bg-indigo-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        ]
                        [ text "Contact support" ]
                    ]
                ]
            ]
        ]