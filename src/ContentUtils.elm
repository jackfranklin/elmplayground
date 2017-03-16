module ContentUtils exposing (..)

import Types exposing (Content, ContentType(..))
import List
import Pages
import Date.Extra
import Posts
import String


allContent : List Content
allContent =
    Pages.pages ++ Posts.posts


findBySlug : List Content -> String -> Maybe Content
findBySlug contentList slug =
    contentList
        |> List.filter (\piece -> piece.slug == slug)
        |> List.head


filterByContentType : List Content -> ContentType -> List Content
filterByContentType contentList contentType =
    List.filter (\c -> c.contentType == contentType) contentList


filterByTitle : List Content -> Maybe String -> List Content
filterByTitle contentList title =
    case title of
        Just title ->
            List.filter (\c -> String.contains (String.toLower title) (String.toLower c.title))
                contentList

        Nothing ->
            sortByDate contentList


findPosts : List Content -> List Content
findPosts contentList =
    filterByContentType contentList Post


latest : List Content -> Content
latest =
    sortByDate >> List.head >> Maybe.withDefault Pages.notFoundContent


sortByDate : List Content -> List Content
sortByDate =
    List.sortWith (flip contentByDateComparison)


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate
