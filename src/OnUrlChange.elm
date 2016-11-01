module OnUrlChange exposing (update)

import Types exposing (Model, Msg, Content)
import FetchContent
import Title
import RemoteData exposing (RemoteData)
import Navigation
import ViewSpecialCases
import ContentUtils


getContentForUrl : String -> Maybe Content
getContentForUrl =
    ContentUtils.findBySlug ContentUtils.allContent


fetchCommand : Content -> Cmd Msg
fetchCommand newItem =
    if ViewSpecialCases.hasSpecialCase newItem then
        Cmd.none
    else
        FetchContent.fetch newItem


newItemCommands : Content -> List (Cmd Msg)
newItemCommands newItem =
    [ fetchCommand newItem, Title.setTitle newItem ]


update : String -> Model -> ( Model, Cmd Msg )
update newUrl model =
    case getContentForUrl newUrl of
        Nothing ->
            model ! [ Navigation.modifyUrl "/404" ]

        Just item ->
            let
                newItem =
                    { item | markdown = RemoteData.Loading }
            in
                { model | currentContent = newItem } ! newItemCommands newItem
