module View exposing (render)

import Html exposing (..)
import Types exposing (Model, Msg)


render : Model -> Html Msg
render model =
    text "Hello World"
