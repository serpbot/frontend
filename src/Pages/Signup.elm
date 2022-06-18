module Pages.Signup exposing (Model, Msg, page)

import Common.Alert exposing (viewAlertFailure, viewAlertSuccess)
import Common.CustomHttp as CustomHttp
import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Response, responseDecoder)
import Common.Spinner exposing (viewSpinnerText)
import Environment exposing (EnvironmentVar)
import Gen.Route
import Html exposing (Html, a, button, dd, div, dl, dt, form, h1, h2, h3, img, input, label, main_, p, span, text)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode
import Page
import Shared
import Request exposing (Request)
import Storage exposing (Storage)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)

page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared.storage req
        , update = update shared
        , view = view shared
        , subscriptions = subscriptions
        }

-- Init

type Status
    = Failure String
    | Success String
    | Loading
    | None

type alias Model =
    { username: String
    , email: String
    , password: String
    , recaptcha: String
    , status: Status
    }

type Msg
    = ChangeUsername String
    | ChangeEmail String
    | ChangePassword String
    | ClickedSignup
    | ReceivedCaptcha String
    | FormSentResp (Result Http.Error Response)
    | NoOp


init: Storage -> Request -> (Model, Cmd Msg)
init storage req =
    let model = Model "" "" "" "" None
    in
    ( model
    , if storage.user /= Nothing && req.route == Gen.Route.Signup then
          Request.replaceRoute Gen.Route.Dashboard req
      else
          Shared.loadhCaptcha
    )


-- Update

signup: EnvironmentVar -> Model -> (Model, Cmd Msg)
signup env model =
    ( model
    , Http.post
        { url = env.serverUrl ++ "/signup"
        , body = Http.jsonBody (encodeModel model)
        , expect = CustomHttp.expectJson FormSentResp responseDecoder
        }
    )

encodeModel: Model -> Encode.Value
encodeModel model =
    Encode.object
        [ ("username", Encode.string model.username)
        , ("password", Encode.string model.password)
        , ("email", Encode.string model.email)
        , ("recaptcha", Encode.string model.recaptcha)
        ]

update: Shared.Model -> Msg -> Model -> (Model, Cmd Msg)
update shared msg model =
    case msg of
        ChangeUsername username ->
            ( { model | username = username }, Cmd.none)

        ChangeEmail email ->
            ( { model | email = email }, Cmd.none)

        ChangePassword password ->
            ( { model | password = password }, Cmd.none)

        ClickedSignup ->
            if model.username == "" then
                ( { model | status = Failure "Username cannot be empty" }, Cmd.none)
            else if model.password == "" then
                ( { model | status = Failure "Password cannot be empty" }, Cmd.none)
            else if model.email == "" then
                ( { model | status = Failure "Email cannot be empty" }, Cmd.none)
            else
                ( { model | status = Loading } , Shared.getCaptchaResponse)

        ReceivedCaptcha captcha ->
            if captcha == "" then
                ( { model | status = Failure "Must fill out captcha" }, Cmd.none)
            else
                signup shared.env { model | recaptcha = captcha }

        FormSentResp result ->
            case result of
                Ok resp ->
                    if resp.status == "failure" then
                        ( { model | username = "", password = "", email = "", recaptcha = "", status = Failure resp.error }, Shared.resetCaptcha ())
                    else
                        case resp.data.info of
                            Just info ->
                                ( { model | status = (Success info) }, Shared.resetCaptcha ())
                            Nothing ->
                                ({ model | status = Failure "Unable to process request, please try again later" }, Shared.resetCaptcha ())
                Err _ ->
                    ({ model | status = Failure "Unable to process request, please try again later" }, Shared.resetCaptcha ())

        _ ->
            (model, Cmd.none)



-- Listen for shared model changes

subscriptions : Model -> Sub Msg
subscriptions _ =
    Shared.messageReceiver ReceivedCaptcha


-- View


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Signup | Serpbot"
    , body = [ div
                [ class "bg-gray-50 h-screen"
                ]
                [ viewHeader shared.storage.user NoOp False
                , viewMain model
                , viewFooter shared.year
                ]
             ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ ]
        [ div
            [ Attr.class "bg-gray-50 relative"
            ]
            [ div
                [ Attr.class "sm:mx-auto sm:w-full sm:max-w-md"
                ]
                [ h2
                    [ Attr.class "mt-6 text-center text-3xl font-extrabold text-gray-900"
                    ]
                    [ text "Create an account" ]
                ]
            , div
                [ Attr.class "mt-8 sm:mx-auto sm:w-full sm:max-w-md"
                ]
                [ div
                    [ Attr.class "bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10"
                    ]
                    [ div
                        [ Attr.class "space-y-6"
                        ]
                        [ case model.status of
                              Failure error ->
                                  viewAlertFailure error
                              Success info ->
                                  viewAlertSuccess info
                              _ ->
                                  div [] []
                        , div []
                            [ label
                                [ Attr.for "username"
                                , Attr.class "block text-sm font-medium text-gray-700"
                                ]
                                [ text "Username" ]
                            , div
                                [ Attr.class "mt-1"
                                ]
                                [ input
                                    [ Attr.id "username"
                                    , Attr.name "username"
                                    , Attr.type_ "username"
                                    , Attr.attribute "autocomplete" "username"
                                    , Attr.class "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    , Attr.value model.username
                                    , onInput ChangeUsername
                                    ]
                                    []
                                ]
                            ]
                        , div []
                            [ label
                                [ Attr.for "email"
                                , Attr.class "block text-sm font-medium text-gray-700"
                                ]
                                [ text "Email address" ]
                            , div
                                [ Attr.class "mt-1"
                                ]
                                [ input
                                    [ Attr.id "email"
                                    , Attr.name "email"
                                    , Attr.type_ "email"
                                    , Attr.attribute "autocomplete" "email"
                                    , Attr.class "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    , Attr.value model.email
                                    , onInput ChangeEmail
                                    ]
                                    []
                                ]
                            ]
                        , div []
                            [ label
                                [ Attr.for "password"
                                , Attr.class "block text-sm font-medium text-gray-700"
                                ]
                                [ text "Password" ]
                            , div
                                [ Attr.class "mt-1"
                                ]
                                [ input
                                    [ Attr.id "password"
                                    , Attr.name "password"
                                    , Attr.type_ "password"
                                    , Attr.attribute "autocomplete" "current-password"
                                    , Attr.class "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                    , Attr.value model.password
                                    , onInput ChangePassword
                                    ]
                                    []
                                ]
                            ]
                        , div [ Attr.id "h-captcha", Attr.class "h-captcha col-md-12"] []
                        , div []
                            [ button
                                [ Attr.class "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                                , onClick ClickedSignup
                                ]
                                ( case model.status of
                                    Loading -> viewSpinnerText
                                    _ -> [ text "Sign up" ]
                                )
                            ]
                        ]
                    ]
                ]
            ]
        ]