module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown
import Pages
import Types exposing (Msg(..))
import Json.Decode
>>>>>>> Get navigation working


-- import Navigation exposing (newUrl)

import Types exposing (Model, Msg, Content)


linkContent : String -> Content -> Html Msg
linkContent str { slug } =
    linkUrl str slug


linkUrl : String -> String -> Html Msg
linkUrl str url =
    a [ href url, navigationOnClick (LinkClicked url) ] [ text str ]


render : Model -> Html Msg
render model =
    div [ class "site-container" ]
        [ navigation model
        , header model
        , body model
        , footer model
        ]


header : Model -> Html Msg
header model =
    Html.header [ class "header" ]
        [ h1 [] [ text "The Elm Playground" ]
        ]


navigation : Model -> Html Msg
navigation model =
    nav [ class "navigation" ]
        [ li [] [ linkContent "Home" Pages.index ]
        , li [] [ linkContent "About" Pages.about ]
        ]


renderContent : Content -> Html Msg
renderContent content =
    case Dict.get content.name specialViews of
        Just view ->
            view <| content

        Nothing ->
            div []
                [ text content.title
                , renderMarkdown content.markdown
                ]


body : Model -> Html Msg
body model =
<<<<<<< HEAD
    section []
        [ renderContent model.currentContent ]
=======
    section [ class "body" ]
        [ h1 [] [ text model.currentContent.title ]
        , renderMarkdown model.currentContent.markdown
        ]
>>>>>>> Get navigation working


convertMarkdownToHtml : WebData String -> List (Html Msg)
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
<<<<<<< HEAD
            Markdown.toHtml [ class "markdown-content" ] data

        Failure e ->
            text "There was an error"
=======
            [ Markdown.toHtml [] data ]

        Failure e ->
            [ text "There was an error" ]
>>>>>>> Get navigation working

        _ ->
            [ text "Loading" ]


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class "markdown-content" ] (convertMarkdownToHtml markdown)


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ text "Copyright Elm Playground" ]


navigationOnClick : Msg -> Attribute Msg
navigationOnClick msg =
    Html.Events.onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (Json.Decode.succeed msg)
