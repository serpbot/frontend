module Pages.Privacy exposing (Model, Msg, page)

import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Html exposing (Html, br, div, h1, h2, li, p, span, text, ul)
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
    { extended: Bool
    }

type Msg
    = ClickedAccount

init: (Model, Cmd Msg)
init =
    (Model False, Cmd.none)


-- Update

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ClickedAccount ->
            if model.extended then
                ({ model | extended = False }, Cmd.none)
            else
                ({ model | extended = True }, Cmd.none)

-- View


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Serpbot | Privacy"
    , body = [ div
                [ class "bg-gray-50"
                ]
                [ viewHeader shared.storage.user ClickedAccount model.extended
                , viewMain
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Html Msg
viewMain =
    div
        [ Attr.class "relative py-16 bg-gray-50 overflow-hidden"
        ]
        [ div
            [ Attr.class "hidden lg:block lg:absolute lg:inset-y-0 lg:h-full lg:w-full"
            ]
            [ div
                [ Attr.class "relative h-full text-lg max-w-prose mx-auto"
                , Attr.attribute "aria-hidden" "true"
                ]
                [ svg
                    [ SvgAttr.class "absolute top-12 left-full transform translate-x-32"
                    , SvgAttr.width "404"
                    , SvgAttr.height "384"
                    , SvgAttr.fill "none"
                    , SvgAttr.viewBox "0 0 404 384"
                    ]
                    [ Svg.defs []
                        [ Svg.pattern
                            [ SvgAttr.id "74b3fd99-0a6f-4271-bef2-e80eeafdf357"
                            , SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "20"
                            , SvgAttr.height "20"
                            , SvgAttr.patternUnits "userSpaceOnUse"
                            ]
                            [ Svg.rect
                                [ SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "4"
                                , SvgAttr.height "4"
                                , SvgAttr.class "text-gray-200"
                                , SvgAttr.fill "currentColor"
                                ]
                                []
                            ]
                        ]
                    , Svg.rect
                        [ SvgAttr.width "404"
                        , SvgAttr.height "384"
                        , SvgAttr.fill "url(#74b3fd99-0a6f-4271-bef2-e80eeafdf357)"
                        ]
                        []
                    ]
                , svg
                    [ SvgAttr.class "absolute top-1/2 right-full transform -translate-y-1/2 -translate-x-32"
                    , SvgAttr.width "404"
                    , SvgAttr.height "384"
                    , SvgAttr.fill "none"
                    , SvgAttr.viewBox "0 0 404 384"
                    ]
                    [ Svg.defs []
                        [ Svg.pattern
                            [ SvgAttr.id "f210dbf6-a58d-4871-961e-36d5016a0f49"
                            , SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "20"
                            , SvgAttr.height "20"
                            , SvgAttr.patternUnits "userSpaceOnUse"
                            ]
                            [ Svg.rect
                                [ SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "4"
                                , SvgAttr.height "4"
                                , SvgAttr.class "text-gray-200"
                                , SvgAttr.fill "currentColor"
                                ]
                                []
                            ]
                        ]
                    , Svg.rect
                        [ SvgAttr.width "404"
                        , SvgAttr.height "384"
                        , SvgAttr.fill "url(#f210dbf6-a58d-4871-961e-36d5016a0f49)"
                        ]
                        []
                    ]
                , svg
                    [ SvgAttr.class "absolute bottom-12 left-full transform translate-x-32"
                    , SvgAttr.width "404"
                    , SvgAttr.height "384"
                    , SvgAttr.fill "none"
                    , SvgAttr.viewBox "0 0 404 384"
                    ]
                    [ Svg.defs []
                        [ Svg.pattern
                            [ SvgAttr.id "d3eb07ae-5182-43e6-857d-35c643af9034"
                            , SvgAttr.x "0"
                            , SvgAttr.y "0"
                            , SvgAttr.width "20"
                            , SvgAttr.height "20"
                            , SvgAttr.patternUnits "userSpaceOnUse"
                            ]
                            [ Svg.rect
                                [ SvgAttr.x "0"
                                , SvgAttr.y "0"
                                , SvgAttr.width "4"
                                , SvgAttr.height "4"
                                , SvgAttr.class "text-gray-200"
                                , SvgAttr.fill "currentColor"
                                ]
                                []
                            ]
                        ]
                    , Svg.rect
                        [ SvgAttr.width "404"
                        , SvgAttr.height "384"
                        , SvgAttr.fill "url(#d3eb07ae-5182-43e6-857d-35c643af9034)"
                        ]
                        []
                    ]
                ]
            ]
        , div
            [ Attr.class "relative px-4 sm:px-6 lg:px-8"
            ]
            [ div
                [ Attr.class "text-lg max-w-prose mx-auto"
                ]
                [ h1 []
                    [ span
                        [ Attr.class "mt-2 block text-3xl text-center leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl"
                        ]
                        [ text "Privacy Policy" ]
                    , br [] []
                    , span
                        [ Attr.class "block text-base text-center text-indigo-600 font-semibold tracking-wide uppercase"
                        ]
                        [ text "Last updated on: June 6th, 2022" ]
                    ]
                ]
            , div
                [ Attr.class "mt-6 prose prose-indigo prose-lg text-gray-500 mx-auto"
                ]
                [ p []
                    [ text "This policy (together with our Terms and Conditions) sets out the basis on which any personal data we collect from you, or that you provide to us, will be processed by us. It applies to serp.bot, serpbot.co and any subdomains e.g. api.serp.bot."]
                , h2 []
                    [ text "Information We May Collect From You" ]
                , p []
                    [ text "We may collect the following data from you:" ]
                , ul
                    [ Attr.attribute "role" "list"
                    ]
                    [ li []
                        [ text "Information that you provide by filling in forms on our site. This includes information provided at the time of registering to use our site." ]
                    , li []
                        [ text "If you contact us, we may keep a record of that correspondence." ]
                    ]
                , p []
                    [ text "Server logs are only used to improve our service and prevent abuse or prohibited use. This information will not be provided under any circumstances to any parties other than when compelled by law." ]
                , h2 []
                    [ text "Protection Of Personal Information" ]
                , p []
                    [ text "We will never misuse, sell, rent, share or give away any personal information to any third parties." ]
                , p []
                    [ text "Our website is open-source and available for anyone (who understands Python/Elm) to view and audit. We use Plausible as our analytics which collects no identifiable information on users." ]
                , h2 []
                    [ text "Your Rights" ]
                , p []
                    [ text "You have the right to request access to personal data that we may process about you." ]
                , p []
                    [ text "You have the right to require us to correct any inaccuracies in your data, free of charge. You can access, correct, update or request deletion of your personal information at any time, either through your online account or by contacting us." ]
                , h2 []
                    [ text "Third party services" ]
                , p []
                    [ text "As mentioned above, we make use of Plausible for our analytics. We also use AWS Cognito for authentication services." ]
                , h2 []
                    [ text "Changes To Our Privacy Policy" ]
                , p []
                    [ text "Any changes we may make to our privacy policy in the future will be posted on this page and, where appropriate, notified to you by e-mail. However, we advise that you check this page regularly to keep up to date with any necessary changes." ]
                ]
            ]
        ]