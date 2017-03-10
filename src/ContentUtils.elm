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
findBySlug allContent slug =
    allContent
        |> List.filter (\piece -> piece.slug == slug)
        |> List.head


filterByContentType : ContentType -> List Content -> List Content
filterByContentType contentType content =
    List.filter (\c -> c.contentType == contentType) content


filterByTitle : Maybe String -> List Content
filterByTitle title =
    case title of
        Just title ->
            List.filter (\c -> String.contains (String.toLower title) (String.toLower c.title))
                Posts.posts

        Nothing ->
            postsInOrder


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
    List.sortWith (flipComparison contentByDateComparison) Posts.posts


watchMeElmPosts : List Content
watchMeElmPosts =
    List.sortWith (flipComparison contentByDateComparison) Posts.watchMeElmPosts


contentByDateComparison : Content -> Content -> Order
contentByDateComparison a b =
    Date.Extra.compare a.publishedDate b.publishedDate


flipComparison : (a -> a -> Order) -> a -> a -> Order
flipComparison =
    flip
