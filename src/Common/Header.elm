module Common.Header exposing (viewHeader)

import Domain.User exposing (User)
import Gen.Route as Route
import Html exposing (Html, a, button, div, header, img, nav, p, span, text)
import Html.Attributes as Attr
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr


viewHeader: Maybe User -> Html msg
viewHeader user =
    header []
        [ div
            [ Attr.class "relative bg-gray-50"
            ]
            [ div
                [ Attr.class "flex justify-between items-center max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8"
                ]
                [ div
                    [ Attr.class "flex justify-start lg:w-0 lg:flex-1"
                    ]
                    [ a
                        [ (case user of
                            Just _ -> Attr.href (Route.toHref Route.Dashboard)
                            _ -> Attr.href (Route.toHref Route.Home_)
                        )
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Workflow" ]
                        , img
                            [ Attr.class "h-8 w-auto sm:h-10"
                            , Attr.src "/img/logo.png"
                            , Attr.alt ""
                            ]
                            []
                        ]
                    ]
                , div
                    [ Attr.class "-mr-2 -my-2 md:hidden"
                    ]
                    [ button
                        [ Attr.type_ "button"
                        , Attr.class "bg-gray-50 rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
                        , Attr.attribute "aria-expanded" "false"
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Open menu" ]
                        ,                         {- Heroicon name: outline/menu -}
                        svg
                            [ SvgAttr.class "h-6 w-6"
                            , SvgAttr.fill "none"
                            , SvgAttr.viewBox "0 0 24 24"
                            , SvgAttr.stroke "currentColor"
                            , Attr.attribute "aria-hidden" "true"
                            ]
                            [ path
                                [ SvgAttr.strokeLinecap "round"
                                , SvgAttr.strokeLinejoin "round"
                                , SvgAttr.strokeWidth "2"
                                , SvgAttr.d "M4 6h16M4 12h16M4 18h16"
                                ]
                                []
                            ]
                        ]
                    ]
                , div
                    [ Attr.class "hidden md:flex items-center justify-end md:flex-1 lg:w-0"
                    ]
                    (case user of
                        Just _ ->
                            [ a
                                [ Attr.href (Route.toHref Route.Logout )
                                , Attr.class "ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                                ]
                                [ text "Logout" ]
                            ]
                        Nothing ->
                            [ a
                                [ Attr.href (Route.toHref Route.Login )
                                , Attr.class "whitespace-nowrap text-base font-medium text-gray-500 hover:text-gray-900"
                                ]
                                [ text "Sign in" ]
                            , a
                                [ Attr.href (Route.toHref Route.Signup )
                                , Attr.class "ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                                ]
                                [ text "Sign up" ]
                            ]
                    )
                ]
            ]
        ]