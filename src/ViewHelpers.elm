module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events
import Types exposing (..)
import ContentUtils exposing (latestPost)
import Json.Decode
import Date exposing (Date)
import Date.Extra


navigationOnClick : Msg -> Attribute Msg
navigationOnClick msg =
    Html.Events.onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (Json.Decode.succeed msg)


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
        [ h3 [] [ text ("Latest Post: " ++ latestPost.title) ]
        , div []
            [ p [] [ text latestPost.intro ]
            , linkContent "Read more" latestPost
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


renderArchives : Html Msg
renderArchives =
    div []
        [ h4 [] [ text "All posts on Elm Playground" ]
        , ul []
            (List.map renderArchive ContentUtils.postsInOrder)
        ]
