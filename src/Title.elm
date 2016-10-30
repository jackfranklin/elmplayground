port module Title exposing (..)

import Types


port newTitle : String -> Cmd msg


setTitle : Types.Content -> Cmd Types.Msg
setTitle content =
    if content.name == "index" then
        newTitle ""
    else
        newTitle content.title
