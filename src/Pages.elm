module Pages exposing (..)

import Authors
import Date.Extra exposing (fromCalendarDate)
import Date exposing (Month(..))
import Types exposing (Content, ContentType(..))
import RemoteData exposing (RemoteData)


index : Content
index =
    { slug = "/"
    , contentType = Page
    , name = "index"
    , title = "Welcome to Elm Playground"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    }


pages : List Content
pages =
    [ index ]
