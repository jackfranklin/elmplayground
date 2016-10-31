module MyApp exposing (..)

import Html exposing (Html, text)
import Navigation
import Types exposing (Model, Msg(..))
import View
import Pages
import ContentUtils
import FetchContent
import RemoteData exposing (RemoteData)
import Title


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
            let
                piece =
                    ContentUtils.findBySlug ContentUtils.allContent newUrl
            in
                case piece of
                    Nothing ->
                        ( model, Navigation.modifyUrl "/404" )

                    Just item ->
                        let
                            newItem =
                                { item | markdown = RemoteData.Loading }
                        in
                            ( { model | currentContent = newItem }
                            , Cmd.batch
                                [ FetchContent.fetch newItem
                                , Title.setTitle newItem
                                ]
                            )


view : Model -> Html Msg
view model =
    View.render model


toUrl : Model -> String
toUrl model =
    model.currentContent.slug


fromUrl : String -> String
fromUrl url =
    url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .pathname)


urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    update (UrlChange result) model


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = always Sub.none
        }
