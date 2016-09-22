module Types exposing (..)

import Date exposing (Date)


type alias Model =
    { currentPage : Page
    , posts : List Post
    , pages : List Page
    }


type PageCategory
    = Static
    | BlogPost


type alias Post =
    { title : String
    , slug : String
    , publishedDate : Date
    , author : String
    , markdown : String
    }


type alias Page =
    { slug : String
    , category : PageCategory
    , name : String
    }


type Msg
    = NoOp
