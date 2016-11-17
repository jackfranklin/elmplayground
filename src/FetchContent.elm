module FetchContent exposing (fetch)

import Types exposing (Content, Msg(..), ContentType(..))
import Http
import RemoteData


fetch : Content -> Cmd Msg
fetch content =
    Http.getString (urlForContent content)
        |> Http.toTask
        |> RemoteData.asCmd
        |> Cmd.map FetchedContent


urlForContent : Content -> String
urlForContent content =
    let
        loc =
            locationForContentType content.contentType
    in
        "/content/" ++ loc ++ "/" ++ content.name ++ ".md"


locationForContentType : ContentType -> String
locationForContentType contentType =
    case contentType of
        Page ->
            "pages"

        Post ->
            "posts"
