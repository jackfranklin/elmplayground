module MyApp exposing (..)

import Navigation
import Types exposing (Model, Msg(..))
import View
import Pages
import OnUrlChange
import GithubApi
import RemoteData


initialModel : Model
initialModel =
    { currentContent = Pages.index
    , contributors = RemoteData.NotAsked
    }


init : String -> ( Model, Cmd Msg )
init url =
    urlUpdate url initialModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked slug ->
            model ! [ Navigation.newUrl slug ]

        FetchedContent response ->
            let
                currentContent =
                    model.currentContent

                newCurrent =
                    { currentContent | markdown = response }
            in
                { model | currentContent = newCurrent } ! []

        FetchedContributors response ->
            { model | contributors = response } ! []

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
    let
        ( initialModel, initialCmd ) =
            update (UrlChange result) model
    in
        ( initialModel
        , Cmd.batch
            [ initialCmd
            , GithubApi.fetchContributors
            ]
        )


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = View.render
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = always Sub.none
        }
