module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown
import Dict exposing (Dict)
import Views.Index


-- import Navigation exposing (newUrl)

import Types exposing (Model, Msg, Content)


specialViews : Dict String (Content -> Html Msg)
specialViews =
    Dict.fromList
        [ ( "index", Views.Index.render )
        ]


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
    section []
        [ renderContent model.currentContent ]


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
