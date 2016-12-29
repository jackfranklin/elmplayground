module ViewSpecialCases exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, href, placeholder)
import Html.Events exposing (onInput)
import Dict exposing (Dict)
import ViewHelpers


type alias ViewFn =
    Model -> Html Msg


indexIntro : String
indexIntro =
    """
    The Elm Playground is a site aimed at those interested in learning about Elm, a highly
    powerful front end language that is a pleasure to use.
    """


archivesIntro : String
archivesIntro =
    """
    Browse through all the posts from the Elm Playground
    """


watchMeElmIntro : String
watchMeElmIntro =
    """
    All videos in the "Watch me Elm" series are linked to below.
    """


specialCases : Dict String ViewFn
specialCases =
    Dict.fromList
        [ ( "index"
          , \model ->
                (div []
                    [ p [] [ text indexIntro ]
                    , ViewHelpers.renderLatestPost
                    ]
                )
          )
        , ( "archives"
          , \model ->
                (div []
                    [ span [] [ text archivesIntro ]
                    , input
                        [ onInput UpdateSearchPost
                        , placeholder "Search"
                        , class "searchInput"
                        ]
                        []
                    , ViewHelpers.renderArchives model
                    ]
                )
          )
        , ( "watch-me-elm"
          , \model ->
                (div []
                    [ p [] [ text watchMeElmIntro ]
                    , ViewHelpers.renderWatchMeElm
                    ]
                )
          )
        ]


getSpecialCase : String -> Maybe ViewFn
getSpecialCase =
    ((flip Dict.get) specialCases)


hasSpecialCase : Content -> Bool
hasSpecialCase { name } =
    case getSpecialCase name of
        Just _ ->
            True

        Nothing ->
            False
