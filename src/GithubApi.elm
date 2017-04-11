module GithubApi exposing (fetchContributors)

import Http
import RemoteData
import Json.Decode as Decode exposing (Decoder, field)
import Types exposing (Msg(..), GithubContributor)


contributorsUrl : String
contributorsUrl =
    "https://api.github.com/repos/jackfranklin/elmplayground/stats/contributors"


githubRequest : String -> Http.Request (List GithubContributor)
githubRequest token =
    let
        headers =
            [ Http.header "Authorization" token ]
    in
        Http.request
            { method = "GET"
            , headers = headers
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


fetchContributors : String -> Cmd Msg
fetchContributors token =
    githubRequest token
        |> Http.toTask
        |> RemoteData.asCmd
        |> Cmd.map FetchedContributors
