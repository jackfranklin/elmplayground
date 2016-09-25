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
    , publishedDate = fromCalendarDate 2016 Sep 1
    , author = Authors.jack
    , markdown = RemoteData.NotAsked
    , contentType = Post
    }


posts : List Content
posts =
    [ helloWorld ]
