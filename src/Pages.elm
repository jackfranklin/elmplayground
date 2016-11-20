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
    , title = "Elm Playground"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


about : Content
about =
    { slug = "/about"
    , contentType = Page
    , name = "about"
    , title = "About the Elm Playground"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


archives : Content
archives =
    { slug = "/archives"
    , contentType = Page
    , name = "archives"
    , title = "Archives"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


watchMeElm : Content
watchMeElm =
    { slug = "/watch-me-elm"
    , contentType = Page
    , name = "watch-me-elm"
    , title = "Watch Me Elm video series"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


notFoundContent : Content
notFoundContent =
    { title = "Couldn't find content"
    , contentType = Page
    , name = "not-found"
    , slug = "notfound"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


notFound404 : Content
notFound404 =
    { slug = "/404"
    , contentType = Page
    , name = "404"
    , title = "You're lost!"
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , intro = ""
    }


pages : List Content
pages =
    [ index
    , about
    , archives
    , watchMeElm
    , notFound404
    ]
