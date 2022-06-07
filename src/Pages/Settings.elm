module Pages.Settings exposing (Model, Msg, page)

import Common.Alert exposing (viewAlertFailure, viewAlertSuccess)
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Domain.User exposing (User)
import Html exposing (Html, button, div, h2, input, label, main_, p, span, text)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onClick)
import Page
import Shared
import Request exposing (Request)
import View exposing (View)

page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.protected.element <|
        \user ->
            { init = init user
            , update = update
            , view = view shared
            , subscriptions = \_ -> Sub.none
            }
-- Init

type alias Model =
    { status: Status
    , toggled: Bool
    , extended: Bool
    }

type Status
    = Failure String
    | Success String
    | Loading
    | None

type Msg
    = ClickedSave
    | ClickedToggle
    | ClickedAccount

init: User -> (Model, Cmd Msg)
init user =
    (Model Loading user.notifications False, Cmd.none)


-- Update

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ClickedSave ->
            (model, Cmd.none)


        ClickedAccount ->
            if model.extended then
                ({ model | extended = False }, Cmd.none)
            else
                ({ model | extended = True }, Cmd.none)

        ClickedToggle ->
            if model.toggled then
                ({model | toggled = False}, Cmd.none)
            else
                ({model | toggled = True}, Cmd.none)



-- View


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Serpbot | Settings"
    , body = [ div
                [ class "flex flex-col h-screen justify-between bg-gray-50"
                ]
                [ viewHeader shared.storage.user ClickedAccount model.extended
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
                [ text "Account Settings" ]
            ,
            (case model.status of
                Failure error -> viewAlertFailure error
                Success msg -> viewAlertSuccess msg
                _ -> div [] []
            )
            , div
                [ Attr.class "my-6"
                ]
                [ div
                    [ Attr.class "flex items-center justify-between"
                    ]
                    [ span
                        [ Attr.class "flex-grow flex flex-col"
                        ]
                        [ span
                            [ Attr.class "text-sm font-medium text-gray-900"
                            , Attr.id "availability-label"
                            ]
                            [ text "Email notifications" ]
                        , span
                            [ Attr.class "text-sm text-gray-500"
                            , Attr.id "availability-description"
                            , Attr.style "padding-right" "10px"
                            ]
                            [ text "Notifications are sent out daily to inform you of the latest ranking on both Google and Bing" ]
                        ]
                    ,         {- Enabled: "bg-indigo-600", Not Enabled: "bg-gray-200" -}
                    (if model.toggled then
                        button
                            [ Attr.type_ "button"
                            , Attr.class "relative inline-flex flex-shrink-0 h-6 w-11 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 bg-indigo-600"
                            , Attr.attribute "role" "switch"
                            , Attr.attribute "aria-checked" "false"
                            , Attr.attribute "aria-labelledby" "availability-label"
                            , Attr.attribute "aria-describedby" "availability-description"
                            , onClick ClickedToggle
                            ]
                            [
                            span
                                [ Attr.attribute "aria-hidden" "true"
                                , Attr.class "translate-x-5 pointer-events-none inline-block h-5 w-5 rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200"
                                ]
                                []
                            ]

                    else
                        button
                            [ Attr.type_ "button"
                            , Attr.class "bg-gray-200 relative inline-flex flex-shrink-0 h-6 w-11 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                            , Attr.attribute "role" "switch"
                            , Attr.attribute "aria-checked" "false"
                            , Attr.attribute "aria-labelledby" "availability-label"
                            , Attr.attribute "aria-describedby" "availability-description"
                            , onClick ClickedToggle
                            ]
                            [
                            span
                                [ Attr.attribute "aria-hidden" "true"
                                , Attr.class "translate-x-0 pointer-events-none inline-block h-5 w-5 rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200"
                                ]
                                []
                            ]

                    )
                    ]

                ]
            , button
                [ Attr.class "button mt-4 inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                , onClick ClickedSave
                ]
                [ text "Save" ]
            ]
        ]