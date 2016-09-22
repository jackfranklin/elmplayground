module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class)
import Types exposing (Model, Msg)


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
    section [] [ text "body goes here" ]


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ text "Copyright Elm Playground" ]
