module Types exposing (..)

import Date exposing (Date)
import RemoteData exposing (WebData)


type alias Model =
    { currentContent : Content
    , contributors : WebData (List GithubContributor)
    }


type alias Author =
    { name : String
    , avatar : String
    }


type alias GithubContributor =
    { name : String, profileUrl : String }


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
    = UrlChange String
    | FetchedContent (WebData String)
    | LinkClicked String
    | FetchedContributors (WebData (List GithubContributor))
