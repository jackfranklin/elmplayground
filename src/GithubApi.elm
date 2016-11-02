module GithubApi exposing (fetchContributors)

import Task exposing (Task)
import Http
import RemoteData
import GithubToken
import Json.Decode as Decode exposing (Decoder, (:=))
import Types exposing (Msg(..), GithubContributor)


contributorsUrl : String
contributorsUrl =
    "https://api.github.com/repos/jackfranklin/elmplayground/stats/contributors"


requestSettings : Http.Request
requestSettings =
    let
        headers =
            Maybe.map (\tok -> [ ( "Authorization", tok ) ]) GithubToken.token
    in
        { verb = "GET"
        , headers = Maybe.withDefault [] headers
        , url = contributorsUrl
        , body = Http.empty
        }


sendContributorsRequest : Task Http.Error (List GithubContributor)
sendContributorsRequest =
    Http.send Http.defaultSettings requestSettings
        |> Http.fromJson contributorsDecoder


contributorDecoder : Decoder GithubContributor
contributorDecoder =
    Decode.at [ "author" ]
        (Decode.object2 GithubContributor
            ("login" := Decode.string)
            ("html_url" := Decode.string)
        )


contributorsDecoder : Decoder (List GithubContributor)
contributorsDecoder =
    Decode.list contributorDecoder


fetchContributors : Cmd Msg
fetchContributors =
    sendContributorsRequest
        |> RemoteData.asCmd
        |> Cmd.map FetchedContributors
