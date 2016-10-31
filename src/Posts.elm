module Posts exposing (posts)

import Types exposing (Content, ContentType(..))
import Authors
import Date.Extra exposing (fromCalendarDate)
import Date exposing (Month(..))
import RemoteData exposing (RemoteData)


helloWorld : Content
helloWorld =
    { slug = "/hello-world"
    , title = "Hello World"
    , name = "hello-world"
    , publishedDate = fromCalendarDate 2016 Oct 30
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , contentType = Post
    , intro = "Introducing the Elm Playground!"
    }


buildingTheElmPlayground : Content
buildingTheElmPlayground =
    { slug = "/building-the-elm-playground"
    , title = "Building the Elm Playground"
    , name = "building-elm-playground"
    , publishedDate = fromCalendarDate 2016 Oct 31
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , contentType = Post
    , intro = "A blog post on some of the techniques and libraries I used to build the Elm Playground."
    }


posts : List Content
posts =
    [ helloWorld, buildingTheElmPlayground ]
