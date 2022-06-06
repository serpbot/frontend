module Common.Footer exposing (viewFooter)

import Gen.Route as Route
import Html exposing (Html, a, div, footer, nav, p, span, text)
import Html.Attributes as Attr
import Shared
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr

viewFooter: Int -> Html msg
viewFooter year =
    footer
        [ Attr.class "bg-gray-50"
        ]
        [ div
            [ Attr.class "max-w-7xl mx-auto py-12 px-4 overflow-hidden sm:px-6 lg:px-8"
            ]
            [ nav
                [ Attr.class "-mx-5 -my-2 flex flex-wrap justify-center"
                , Attr.attribute "aria-label" "Footer"
                ]
                [ div
                    [ Attr.class "px-5 py-2"
                    ]
                    [ a
                        [ Attr.href (Route.toHref Route.Home_)
                        , Attr.class "text-base text-gray-500 hover:text-gray-900"
                        ]
                        [ text "Home" ]
                    ]
                , div
                    [ Attr.class "px-5 py-2"
                    ]
                    [ a
                        [ Attr.href (Route.toHref Route.Terms)
                        , Attr.class "text-base text-gray-500 hover:text-gray-900"
                        ]
                        [ text "Terms" ]
                    ]
                , div
                    [ Attr.class "px-5 py-2"
                    ]
                    [ a
                        [ Attr.href (Route.toHref Route.Privacy)
                        , Attr.class "text-base text-gray-500 hover:text-gray-900"
                        ]
                        [ text "Privacy" ]
                    ]
                ]
            , p
                [ Attr.class "mt-8 text-center text-base text-gray-400"
                ]
                [ text ("© " ++ String.fromInt year ++ " Serpbot, Inc. All rights reserved.") ]
            ]
        ]
