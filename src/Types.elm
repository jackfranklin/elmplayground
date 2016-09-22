module Types exposing (..)

import Date exposing (Date)


type alias Model =
    { page : Page
    , posts : List Post
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
    , title : String
    }


type Msg
    = NoOp
