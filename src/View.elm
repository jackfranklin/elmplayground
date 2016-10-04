module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown


-- import Navigation exposing (newUrl)

import Types exposing (Model, Msg, Content)


link : String -> Content -> Html Msg
link str content =
    a [] []


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
        [ li [] [ text "Link" ]
        , li [] [ text "Link 2" ]
        ]


body : Model -> Html Msg
body model =
    section []
        [ text model.currentContent.title
        , renderMarkdown model.currentContent.markdown
        ]


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class "markdown-content" ] data

        Failure e ->
            text "There was an error"

        _ ->
            text "Loading"


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ text "Copyright Elm Playground" ]
