module ContentUtils exposing (..)

import Types exposing (Content, ContentType(..))
import List
import Pages
import Date.Extra
import Posts


findBySlug : List Content -> String -> Maybe Content
findBySlug allContent slug =
    allContent
        |> List.filter (\piece -> piece.slug == slug)
        |> List.head


filterByContentType : ContentType -> List Content -> List Content
filterByContentType contentType content =
    List.filter (\c -> c.contentType == contentType) content


findPosts : List Content -> List Content
findPosts =
    filterByContentType Post


latestPost : Content
latestPost =
    Posts.posts
        |> List.sortWith contentByDateComparison
        |> List.head
        |> Maybe.withDefault Pages.notFoundContent


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate
