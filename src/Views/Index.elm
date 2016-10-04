module Views.Index exposing (render)

import Types exposing (Content, Msg)
import Html exposing (..)
import Posts exposing (posts)


renderPost : Content -> Html Msg
renderPost post =
    div [] [ text ("I am a post" ++ post.title) ]


renderPosts : Html Msg
renderPosts =
    ul [] (List.map renderPost posts)


render : Content -> Html Msg
render content =
    div []
        [ renderPosts
        ]
