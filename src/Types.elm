module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)


type alias Model =
    { allContent : List Content
    , currentContent : Content
    }


type alias Author =
    { name : String
    , avatar : String
    }


type ContentType
    = Page
    | Post


type alias Content =
    { title : String
    , name : String
    , slug : String
    , publishedDate : Date
    , author : Author
    , markdown : WebData String
    , contentType : ContentType
    }


type Msg
    = NoOp
    | UrlChange String
    | FetchedContent (WebData String)
    | LinkClicked String
