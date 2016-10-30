module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown
import Pages
import Types exposing (Msg(..))
import ViewSpecialCases
import Types exposing (Model, Msg, Content)
import ViewHelpers exposing (linkContent)


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
        [ img [ src "/img/elm.png" ] []
        , h1 [] [ text "The Elm Playground" ]
        ]


navigation : Model -> Html Msg
navigation model =
    nav [ class "navigation" ]
        [ li [] [ linkContent "Home" Pages.index ]
        , li [] [ linkContent "About" Pages.about ]
        ]


body : Model -> Html Msg
body model =
    section [ class "body" ]
        [ mainBody model, subContent ]


subContent : Html Msg
subContent =
    div [ class "subContent" ]
        [ p [] [ text "" ] ]


mainBody : Model -> Html Msg
mainBody model =
    div [ class "mainBody" ]
        [ h1 [] [ text model.currentContent.title ]
        , renderContent model
        ]


convertMarkdownToHtml : WebData String -> Html Msg
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class "markdown-content" ] data

        Failure e ->
            text "There was an error"

        _ ->
            text "Loading"


renderContent : Model -> Html Msg
renderContent model =
    case ViewSpecialCases.getSpecialCase model.currentContent.name of
        Just fn ->
            article [ class "fn-content" ] [ (fn model) ]

        Nothing ->
            renderMarkdown model.currentContent.markdown


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class "markdown-content" ] [ convertMarkdownToHtml markdown ]


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ text "Copyright Elm Playground" ]
