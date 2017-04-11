module MyApp exposing (..)

import Navigation
import Types exposing (Flags, Model, Msg(..))
import View
import Pages
import OnUrlChange
import GithubApi
import RemoteData


initialModel : Model
initialModel =
    { currentContent = Pages.index
    , contributors = RemoteData.NotAsked
    , searchPost = Nothing
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        { github_token } =
            flags

        ( modelWithFirstUrl, initialCmd ) =
            update (UrlChange location) initialModel
    in
        ( modelWithFirstUrl
        , Cmd.batch
            [ initialCmd
            , GithubApi.fetchContributors github_token
            ]
        )


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

        UrlChange location ->
            OnUrlChange.update location.pathname model

        UpdateSearchPost title ->
            { model | searchPost = Just title } ! []


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = View.render
        , update = update
        , subscriptions = always Sub.none
        }
