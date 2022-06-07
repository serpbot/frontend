module Pages.Home_ exposing (Model, Msg, page)

import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Gen.Route as Route
import Html exposing (Html, a, dd, div, dl, dt, h1, h2, img, main_, p, span, text)
import Html.Attributes as Attr exposing (class)
import Page
import Shared
import Request exposing (Request)
import Svg exposing (path, svg)
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
    { title = "Serpbot | Home"
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
    main_ []
        [ div []
            [
            div
                [ Attr.class "bg-gray-50 relative"
                ]
                [ div
                    [ Attr.class "absolute inset-x-0 bottom-0 h-1/2 bg-gray-50"
                    ]
                    []
                , div
                    [ Attr.class "max-w-7xl mx-auto sm:px-6 lg:px-8"
                    ]
                    [ div
                        [ Attr.class "relative shadow-xl sm:rounded-2xl sm:overflow-hidden"
                        ]
                        [ div
                            [ Attr.class "absolute inset-0"
                            ]
                            [ img
                                [ Attr.class "h-full w-full object-cover"
                                , Attr.src "/img/team.jpeg"
                                , Attr.alt "People working on laptops"
                                ]
                                []
                            , div
                                [ Attr.class "absolute inset-0 bg-indigo-700 mix-blend-multiply"
                                ]
                                []
                            ]
                        , div
                            [ Attr.class "relative px-4 py-16 sm:px-6 sm:py-24 lg:py-32 lg:px-8"
                            ]
                            [ h1
                                [ Attr.class "text-center text-4xl font-extrabold tracking-tight sm:text-5xl lg:text-6xl"
                                ]
                                [ span
                                    [ Attr.class "block text-white"
                                    ]
                                    [ text "Take control of your" ]
                                , span
                                    [ Attr.class "block text-indigo-200"
                                    ]
                                    [ text "page rank" ]
                                ]
                            , p
                                [ Attr.class "mt-6 max-w-lg mx-auto text-center text-xl text-indigo-200 sm:max-w-3xl"
                                ]
                                [ text "We make it easy and affordable to monitor your website rank on both Google and Bing through our automated system" ]
                            , div
                                [ Attr.class "mt-10 max-w-sm mx-auto sm:max-w-none sm:flex sm:justify-center"
                                ]
                                [ div
                                    [ Attr.class "space-y-4 sm:space-y-0 sm:mx-auto sm:inline-grid sm:grid-cols sm:gap-5"
                                    ]
                                    [ a
                                        [ Attr.href (Route.toHref Route.Signup)
                                        , Attr.class "flex items-center justify-center px-4 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-indigo-700 bg-gray-50 hover:bg-indigo-50 sm:px-8"
                                        ]
                                        [ text "Get started" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ,
        div
            [ Attr.class "bg-gray-50"
            ]
            [ div
                [ Attr.class "max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-24 lg:px-8 lg:grid lg:grid-cols-3 lg:gap-x-8"
                ]
                [ div []
                    [ h2
                        [ Attr.class "text-base font-semibold text-indigo-600 uppercase tracking-wide"
                        ]
                        [ text "Everything you need" ]
                    , p
                        [ Attr.class "mt-2 text-3xl font-extrabold text-gray-900"
                        ]
                        [ text "All-in-one platform" ]
                    ]
                , div
                    [ Attr.class "mt-12 lg:mt-0 lg:col-span-2"
                    ]
                    [ dl
                        [ Attr.class "space-y-10 sm:space-y-0 sm:grid sm:grid-cols-2 sm:grid-rows-4 sm:grid-flow-col sm:gap-x-6 sm:gap-y-10 lg:gap-x-8"
                        ]
                        [ div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [                                 {- Heroicon name: outline/check -}
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Email notifications" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "You can opt into receiving daily, weekly or monthly notifications to see how your websites are doing" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Monitor Google and Bing" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "Most search engine ranking tools stop at Google, we offer the possibility of monitoring both Bing and Google" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [                                 {- Heroicon name: outline/check -}
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Graphical representation" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "We make it easy to visualize your ranking through a nice graphical representation" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Open source" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "The complete source code is available on ", a
                                    [ Attr.href "https://github.com/serpbot"
                                    , Attr.class "font-medium text-indigo-600 hover:text-indigo-500"
                                    ]
                                    [ text " github" ]
                                ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Historical data" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "We keep your historical data for up to 365 days so that you can visualize your progress" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [                                 {- Heroicon name: outline/check -}
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Free" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "You can use this service for free, but there are certain limits (see FAQ)" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Unlimited keywords" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "We won't limit the amount of keywords that you monitor (see FAQ)" ]
                            ]
                        , div
                            [ Attr.class "relative"
                            ]
                            [ dt []
                                [
                                svg
                                    [ SvgAttr.class "absolute h-6 w-6 text-green-500"
                                    , SvgAttr.fill "none"
                                    , SvgAttr.viewBox "0 0 24 24"
                                    , SvgAttr.stroke "currentColor"
                                    , Attr.attribute "aria-hidden" "true"
                                    ]
                                    [ path
                                        [ SvgAttr.strokeLinecap "round"
                                        , SvgAttr.strokeLinejoin "round"
                                        , SvgAttr.strokeWidth "2"
                                        , SvgAttr.d "M5 13l4 4L19 7"
                                        ]
                                        []
                                    ]
                                , p
                                    [ Attr.class "ml-9 text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Unlimited websites" ]
                                ]
                            , dd
                                [ Attr.class "mt-2 ml-9 text-base text-gray-500"
                                ]
                                [ text "We won't limit the amount of websites that you can monitor (see FAQ)" ]
                            ]
                        ]
                    ]
                ]
            ]
        ,
        div
            [ Attr.class "bg-gray-50"
            ]
            [ div
                [ Attr.class "max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:py-20 lg:px-8"
                ]
                [ div
                    [ Attr.class "lg:grid lg:grid-cols-3 lg:gap-8"
                    ]
                    [ div []
                        [ h2
                            [ Attr.class "text-3xl font-extrabold text-gray-900"
                            ]
                            [ text "Frequently asked questions" ]
                        , p
                            [ Attr.class "mt-4 text-lg text-gray-500"
                            ]
                            [ text "Can’t find the answer you’re looking for? Reach out to our", a
                                [ Attr.href "mailto:support@serp.bot"
                                , Attr.class "font-medium text-indigo-600 hover:text-indigo-500"
                                ]
                                [ text " customer support " ]
                            , text "team." ]
                        ]
                    , div
                        [ Attr.class "mt-12 lg:mt-0 lg:col-span-2"
                        ]
                        [ dl
                            [ Attr.class "space-y-12"
                            ]
                            [ div []
                                [ dt
                                    [ Attr.class "text-lg leading-6 font-medium text-gray-900"
                                    ]
                                    [ text "Why is it called Serpbot?" ]
                                , dd
                                    [ Attr.class "mt-2 text-base text-gray-500"
                                    ]
                                    [ text "Serp stands for Serp Engine Rank Page. It is a common term used by the SEO crowd. It also perfectly explains the purpose of this application." ]
                                ]
                            , div []
                                [ dt
                                [ Attr.class "text-lg leading-6 font-medium text-gray-900"
                                ]
                                [ text "Is it really free?" ]
                                , dd
                                    [ Attr.class "mt-2 text-base text-gray-500"
                                    ]
                                    [ text "Yes, at least for the time being. Running a website cost money, especially if a lot of people use it. I am relying on donations to keep it up, so if you're feeling generous, please donate." ]
                                    ]
                            , div []
                                [ dt
                                [ Attr.class "text-lg leading-6 font-medium text-gray-900"
                                ]
                                [ text "Are there any limits to the free usage?" ]
                                , dd
                                    [ Attr.class "mt-2 text-base text-gray-500"
                                    ]
                                    [ text "Yes, there are limits. Each user is limited to 5 websites. Additionally, only the top 100 results are checked. Anything more than that will show 0." ]
                                    ]
                            , div []
                                [ dt
                                [ Attr.class "text-lg leading-6 font-medium text-gray-900"
                                ]
                                [ text "Can I self-host and remove the limits?" ]
                                , dd
                                    [ Attr.class "mt-2 text-base text-gray-500"
                                    ]
                                    [ text "Absolutely! The entire source code is currently available on github, so you can remove limits or make any other change that you would like. I will be publishing a guide shortly on how to proceed." ]
                                    ]
                            ]
                        ]
                    ]
                ]
            ]
        ,
        div
            [ Attr.class "bg-gray-50"
            ]
            [ div
                [ Attr.class "max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8 lg:flex lg:items-center lg:justify-between"
                ]
                [ h2
                    [ Attr.class "text-3xl font-extrabold tracking-tight text-gray-900 sm:text-4xl"
                    ]
                    [ span
                        [ Attr.class "block"
                        ]
                        [ text "Ready to dive in?" ]
                    , span
                        [ Attr.class "block text-indigo-600"
                        ]
                        [ text "Sign up for free." ]
                    ]
                , div
                    [ Attr.class "mt-8 flex lg:mt-0 lg:flex-shrink-0"
                    ]
                    [ div
                        [ Attr.class "inline-flex rounded-md shadow"
                        ]
                        [ a
                            [ Attr.href (Route.toHref Route.Signup)
                            , Attr.class "inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
                            ]
                            [ text "Get started" ]
                        ]
                    ]
                ]
            ]
        ]