module MyApp exposing (..)

import Html exposing (Html, text)
import Html.App as App
import Types exposing (Model, Msg(..))
import View
import Pages


initialModel : Model
initialModel =
    { page = Pages.index
    , posts = []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    View.render model


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
