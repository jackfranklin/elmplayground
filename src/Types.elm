module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)
import Html exposing (Html)


type alias Model =
    { currentContent : Content
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
    , intro : String
    }


type Msg
    = NoOp
    | UrlChange String
    | FetchedContent (WebData String)
    | LinkClicked String
