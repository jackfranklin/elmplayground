module OnUrlChange exposing (update)

import Types exposing (Model, Msg)
import FetchContent
import Title
import RemoteData exposing (RemoteData)
import Navigation
import ContentUtils


update : String -> Model -> ( Model, Cmd Msg )
update newUrl model =
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
