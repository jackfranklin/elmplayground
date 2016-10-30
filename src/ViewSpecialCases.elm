module ViewSpecialCases exposing (..)

import Types exposing (Model, Msg)
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
        ]


getSpecialCase : String -> Maybe ViewFn
getSpecialCase =
    ((flip Dict.get) specialCases)
