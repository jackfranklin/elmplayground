module Pages exposing (..)

import Types exposing (Page, PageCategory(..))


index : Page
index =
    { slug = "/"
    , category = Static
    , name = "index"
    }


pages : List Page
pages =
    [ index ]
