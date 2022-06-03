module Common.Spinner exposing (viewSpinnerText)

import Html exposing (Html, span, text)
import Html.Attributes as Attr
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr

viewSpinnerText: List(Html msg)
viewSpinnerText =
    [ svg
          [ SvgAttr.class "animate-spin -ml-1 mr-3 h-5 w-5 text-white"
          , SvgAttr.fill "none"
          , SvgAttr.viewBox "0 0 24 24"
          ]
          [ Svg.circle
              [ SvgAttr.class "opacity-25"
              , SvgAttr.cx "12"
              , SvgAttr.cy "12"
              , SvgAttr.r "10"
              , SvgAttr.stroke "currentColor"
              , SvgAttr.strokeWidth "4"
              ]
              []
          , path
              [ SvgAttr.class "opacity-75"
              , SvgAttr.fill "currentColor"
              , SvgAttr.d "M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              ]
              []
          ]
      , text "Loading..."
    ]