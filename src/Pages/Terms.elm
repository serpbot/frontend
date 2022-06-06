module Pages.Terms exposing (Model, Msg, page)

import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Html exposing (Html, br, div, h1, h2, p, span, text)
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
    { title = "Serpbot | Privacy"
    , body = [ div
                [ class "bg-gray-50"
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
                        [ text "Terms of Service" ]
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
                    [ text "Please read these terms of use carefully before you start to use the site. By using our site, you indicate that you accept these terms of use and that you agree to abide by them. If you do not agree to these terms of use, please refrain from using our site."]
                , h2 []
                    [ text "Accounts" ]
                , p []
                    [ text "You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service." ]
                , p []
                    [ text "You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorised use of your account." ]
                , h2 []
                    [ text "Termination" ]
                , p []
                    [ text "We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever. that includes mass signups for the purpose of discount code/coupon harvesting or other similar activity, disrupting the Service's networks or servers, any activity that aims to deteriorate the Service's reliability, including without limitation if you breach the Terms of Service."]
                , p []
                    [ text "Accounts registered by bots or any automated methods are not authorised and will be terminated." ]
                , p []
                    [ text "Having multiple free accounts is not considered an acceptable use of our service. Any users found to be abusing this rule may have their accounts terminated." ]
                , p []
                    [ text "All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability." ]
                , p []
                    [ text "Upon termination, your right to use the Service will immediately cease. If you wish to terminate your account, you may simply contact us." ]
                , h2 []
                    [ text "Intellectual Property Rights"]
                , p []
                    [ text "We are the owner or the licensee of all intellectual property rights in our site, and in the material published on it. Those works are protected by copyright laws and treaties around the world. All such rights are reserved." ]
                , p []
                    [ text "Note that you are not prohibited from using the open source code for the Service to create your own service, whether you charge a fee or not, provided you do not use the servers, bandwidth, and other similar resources of our Service to provide your service." ]
                , h2 []
                    [ text "Limitation Of Liability" ]
                , p []
                    [ text "We do not accept any responsibility for any loss which may arise from accessing or reliance on the information on this site and to the fullest extent permitted by English law, we exclude all liability for loss or damages direct or indirect arising from use of this site." ]
                , h2 []
                    [ text "Disclaimer" ]
                , p []
                    [ text "Your use of the Service is at your sole risk. The Service is provided on an 'as if' and 'as available' basis. The Service is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance." ]
                , p []
                    [ text "Access to our site is permitted on a temporary basis, and we reserve the right to withdraw or amend the service we provide on our site without notice. We will not be liable if for any reason our site is unavailable at any time or for any period." ]
                , p []
                    [ text "In no event shall the authors or copyright holders be liable for any claim, damages or liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software." ]
                , h2 []
                    [ text "Jurisdiction And Applicable Law" ]
                , p []
                    [ text "The Quebec courts will have non-exclusive jurisdiction over any claim arising from, or related to, a visit to our site." ]
                , p []
                    [ text "These terms of use and any dispute or claim arising out of or in connection with them or their subject matter or formation (including non-contractual disputes or claims) shall be governed by and construed in accordance with the civil law of Quebec" ]
                , h2 []
                    [ text "Change" ]
                , p []
                    [ text "We may revise these terms of use at any time by amending this page. You are expected to check this page from time to time to take notice of any changes we made, as they are binding on you. Some of the provisions contained in these terms of use may also be superseded by provisions or notices published elsewhere on our site." ]
                ]
            ]
        ]