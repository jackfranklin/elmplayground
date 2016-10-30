module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events
import Types exposing (..)
import ContentUtils exposing (latestPost)
import Json.Decode


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


renderLatestPost : Html Msg
renderLatestPost =
    div []
        [ h3 [] [ text ("Latest Post: " ++ latestPost.title) ]
        , div []
            [ p [] [ text latestPost.intro ]
            , linkContent "Read more" latestPost
            ]
        ]
