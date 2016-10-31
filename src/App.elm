module MyApp exposing (..)

import Html exposing (Html, text)
import Navigation
import Types exposing (Model, Msg(..))
import View
import Pages
import OnUrlChange


initialModel : Model
initialModel =
    { currentContent = Pages.index
    }


init : String -> ( Model, Cmd Msg )
init url =
    urlUpdate url initialModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked slug ->
            ( model, Navigation.newUrl slug )

        FetchedContent response ->
            let
                content' =
                    model.currentContent

                newCurrent =
                    { content' | markdown = response }
            in
                ( { model | currentContent = newCurrent }, Cmd.none )

        UrlChange newUrl ->
            OnUrlChange.update newUrl model


toUrl : Model -> String
toUrl model =
    model.currentContent.slug


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser .pathname


urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    update (UrlChange result) model


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = View.render
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = always Sub.none
        }
