module Common.Footer exposing (viewFooter)

import Html exposing (Html, div, footer, p, text)
import Html.Attributes as Attr
import Shared

viewFooter: Int -> Html msg
viewFooter year =
    footer
        [ Attr.class "h-10"
        ]
        [ div
            [ Attr.class "px-4 md:flex md:items-center md:justify-between lg:px-8"
            ]
            [ div
                [ Attr.class "mt-8 md:mt-0 md:order-1"
                ]
                [ p
                    [ Attr.class "text-center text-base text-gray-400"
                    ]
                    [ text ("© " ++ String.fromInt year ++ " Serpbot, Inc. All rights reserved.") ]
                ]
            ]
        ]
