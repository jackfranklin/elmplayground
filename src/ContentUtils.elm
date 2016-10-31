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
    postsInOrder
        |> List.head
        |> Maybe.withDefault Pages.notFoundContent


postsInOrder : List Content
postsInOrder =
    List.sortWith contentByDateComparison Posts.posts


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate
