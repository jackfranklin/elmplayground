module ViewSpecialCases exposing (..)

import Types exposing (Model, Msg, Content)
import Html exposing (..)
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
                    [ p [] [ text archivesIntro ]
                    , ViewHelpers.renderArchives
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
