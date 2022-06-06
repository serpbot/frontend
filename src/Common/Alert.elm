module Common.Alert exposing (viewAlertSuccess, viewAlertFailure)

import Html exposing (Html, div, h3, li, text, ul)
import Html.Attributes as Attr
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr

viewAlertSuccess: String -> Html msg
viewAlertSuccess message =
    div
        [ Attr.class "rounded-md bg-green-50 p-4"
        ]
        [ div
            [ Attr.class "flex"
            ]
            [ div
                [ Attr.class "flex-shrink-0"
                ]
                [
                svg
                    [ SvgAttr.class "h-5 w-5 text-green-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.class "ml-3"
                ]
                [ h3
                    [ Attr.class "text-sm font-medium text-green-800"
                    ]
                    [ text message ]
                ]
            ]
        ]


viewAlertFailure: String -> Html msg
viewAlertFailure message =
    div
        [ Attr.class "rounded-md bg-red-50 p-4"
        ]
        [ div
            [ Attr.class "flex"
            ]
            [ div
                [ Attr.class "flex-shrink-0"
                ]
                [                 {- Heroicon name: solid/x-circle -}
                svg
                    [ SvgAttr.class "h-5 w-5 text-red-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.class "ml-3"
                ]
                [ h3
                    [ Attr.class "text-sm font-medium text-red-800"
                    ]
                    [ text message ]
                ]
            ]
        ]