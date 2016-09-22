module Pages exposing (..)

import Types exposing (Page, PageCategory(..))


index : Page
index =
    { slug = "/"
    , category = Static
    , title = "Welcome to Elm Playground"
    }


pages : List Page
pages =
    [ index ]
