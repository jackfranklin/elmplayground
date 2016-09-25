module ContentUtils exposing (..)

import Types exposing (Content)
import List


findBySlug : List Content -> String -> Maybe Content
findBySlug pieces slug =
    List.filter
        (\piece ->
            piece.slug == slug
        )
        pieces
        |> List.head
