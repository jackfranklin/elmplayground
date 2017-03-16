module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events
import Types exposing (..)
import ContentUtils
import Json.Decode as Decode
import Date exposing (Date)
import Date.Extra
import Posts


navigationOnClick : Msg -> Attribute Msg
navigationOnClick msg =
    Html.Events.onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (Decode.succeed msg)


linkContent : String -> Content -> Html Msg
linkContent str { slug } =
    linkUrl str slug


linkUrl : String -> String -> Html Msg
linkUrl str url =
    a [ href url, navigationOnClick (LinkClicked url) ] [ text str ]


externalLink : String -> String -> Html Msg
externalLink str url =
    a [ href url ] [ text str ]


renderLatestPost : Html Msg
renderLatestPost =
    div []
        [ h3 [] [ text ("Latest Post: " ++ .title (ContentUtils.latest Posts.posts)) ]
        , div []
            [ p [] [ text <| .intro <| ContentUtils.latest Posts.posts ]
            , linkContent "Read more" <| ContentUtils.latest Posts.posts
            ]
        ]


formatDate : Date -> String
formatDate =
    Date.Extra.toFormattedString "MMMM ddd, y"


renderArchive : Content -> Html Msg
renderArchive content =
    li [ class "archive-link" ]
        [ h4 [] [ linkContent content.title content ]
        , p []
            [ text
                ("Published on " ++ formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
            ]
        ]


renderArchives : Model -> Html Msg
renderArchives model =
    div []
        [ h4 [] [ text "All posts on Elm Playground" ]
        , ul []
            (List.map renderArchive <| ContentUtils.filterByTitle Posts.posts model.searchPost)
        ]


renderWatchMeElm : Html Msg
renderWatchMeElm =
    div []
        [ ul []
            (List.map renderArchive <| ContentUtils.sortByDate Posts.watchMeElmPosts)
        ]
