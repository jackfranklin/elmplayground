module GithubApi exposing (fetchContributors)

import Http
import RemoteData
import GithubToken
import Json.Decode as Decode exposing (Decoder, field)
import Types exposing (Msg(..), GithubContributor)


contributorsUrl : String
contributorsUrl =
    "https://api.github.com/repos/jackfranklin/elmplayground/stats/contributors"


githubRequest : Http.Request (List GithubContributor)
githubRequest =
    let
        headers =
            Maybe.map (\tok -> [ Http.header "Authorization" tok ]) GithubToken.token
    in
        Http.request
            { method = "GET"
            , headers = Maybe.withDefault [] headers
            , url = contributorsUrl
            , body = Http.emptyBody
            , expect = Http.expectJson contributorsDecoder
            , timeout = Nothing
            , withCredentials = False
            }


contributorDecoder : Decoder GithubContributor
contributorDecoder =
    Decode.at [ "author" ]
        (Decode.map2 GithubContributor
            (field "login" Decode.string)
            (field "html_url" Decode.string)
        )


contributorsDecoder : Decoder (List GithubContributor)
contributorsDecoder =
    Decode.list contributorDecoder


fetchContributors : Cmd Msg
fetchContributors =
    githubRequest
        |> Http.toTask
        |> RemoteData.asCmd
        |> Cmd.map FetchedContributors
