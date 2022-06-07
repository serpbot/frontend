module Common.Header exposing (viewHeader)

import Domain.User exposing (User)
import Gen.Route as Route
import Html exposing (Html, a, button, div, header, img, li, nav, p, span, text, ul)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr

viewHeader: Maybe User -> msg -> Bool -> Html msg
viewHeader user msg extended =
    header []
        [ div
            [ Attr.class "bg-gray-50"
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
                        Just u ->
                            [ ul
                                [ Attr.class "flex w-full sm:w-auto"
                                ]
                                [ li
                                    [ Attr.class "hidden mr-6 sm:block"
                                    ]
                                    [ a
                                        [ Attr.class "font-bold rounded m-1 p-1 hover:bg-gray-200 dark:hover:bg-gray-900 dark:text-gray-100"
                                        , Attr.href "https://docs.serp.bot"
                                        , Attr.rel "noreferrer"
                                        , Attr.style "line-height" "40px"
                                        , Attr.target "_blank"
                                        ]
                                        [ text "Docs" ]
                                    ]
                                , li
                                    [ Attr.class "w-full sm:w-auto"
                                    ]
                                    [ div
                                        [ Attr.class "relative font-bold rounded"
                                        ]
                                        [ div
                                            [ Attr.attribute "data-dropdown-trigger" ""
                                            , Attr.class "flex items-center justify-end p-1 m-1 rounded cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-900 dark:text-gray-100"
                                            ]
                                            [ span
                                                [ Attr.class "pl-2 mr-2 truncate"
                                                , onClick msg
                                                ]
                                                [ text u.username ]
                                            , svg
                                                [ SvgAttr.style "height: 18px; transform: translateY(2px); fill: #606f7b;"
                                                , SvgAttr.version "1.1"
                                                , SvgAttr.x "0px"
                                                , SvgAttr.y "0px"
                                                , SvgAttr.viewBox "0 0 512 640"
                                                , SvgAttr.enableBackground "new 0 0 512 512"
                                                , SvgAttr.xmlSpace "preserve"
                                                ]
                                                [ Svg.g []
                                                    [ Svg.circle
                                                        [ SvgAttr.cx "256"
                                                        , SvgAttr.cy "52.8"
                                                        , SvgAttr.r "50.8"
                                                        ]
                                                        []
                                                    , Svg.circle
                                                        [ SvgAttr.cx "256"
                                                        , SvgAttr.cy "256"
                                                        , SvgAttr.r "50.8"
                                                        ]
                                                        []
                                                    , Svg.circle
                                                        [ SvgAttr.cx "256"
                                                        , SvgAttr.cy "459.2"
                                                        , SvgAttr.r "50.8"
                                                        ]
                                                        []
                                                    ]
                                                ]
                                            ]
                                        , div
                                            [ Attr.attribute "data-dropdown" ""
                                            , Attr.style "top" "42px"
                                            , Attr.style "right" "0px"
                                            , Attr.style "width" "185px"
                                            , (if extended then
                                                Attr.class "absolute right-0 bg-white border border-gray-300 rounded shadow-md dropdown-content dark:bg-gray-800 dark:border-gray-500"
                                              else
                                                Attr.class "absolute right-0 bg-white border border-gray-300 rounded shadow-md dropdown-content dark:bg-gray-800 dark:border-gray-500 hidden"
                                            )
                                            ]
                                            [ a
                                                [ Attr.class "block py-2 px-2 border-b border-gray-300 dark:border-gray-500 hover:bg-gray-100 dark:hover:bg-gray-900 dark:text-gray-100"
                                                , Attr.href (Route.toHref Route.Settings)
                                                ]
                                                [ text "Settings" ]
                                            , a
                                                [ Attr.class "block py-2 px-2 hover:bg-gray-100 dark:hover:bg-gray-900 dark:text-gray-100"
                                                , Attr.href (Route.toHref Route.Logout)
                                                ]
                                                [ text "Log out" ]
                                            ]
                                        ]
                                    ]
                                , li
                                    [ Attr.id "changelog-notification"
                                    , Attr.class "relative py-2"
                                    ]
                                    []
                                ]
                            ]
                        Nothing ->
                            [ a
                                [ Attr.href (Route.toHref Route.Login)
                                , Attr.class "whitespace-nowrap text-base font-medium text-gray-500 hover:text-gray-900"
                                ]
                                [ text "Sign in" ]
                            , a
                                [ Attr.href (Route.toHref Route.Signup)
                                , Attr.class "ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700"
                                ]
                                [ text "Sign up" ]
                            ]
                    )
                ]
            ]
        ]