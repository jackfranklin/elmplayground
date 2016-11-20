module View exposing (render)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import RemoteData exposing (WebData, RemoteData(..))
import Markdown
import Pages
import Types exposing (Msg(..), GithubContributor)
import ViewSpecialCases
import Types exposing (Model, Msg, Content)
import ViewHelpers exposing (linkContent, externalLink)


render : Model -> Html Msg
render model =
    div [ class "site-container" ]
        [ navigation model
        , header model
        , body model
        , footer model
        ]


header : Model -> Html Msg
header model =
    Html.header [ class "header" ]
        [ img [ src "/img/elm.png" ] []
        , h1 [] [ text "The Elm Playground" ]
        ]


navigation : Model -> Html Msg
navigation model =
    nav [ class "navigation" ]
        [ li [] [ linkContent "Home" Pages.index ]
        , li [] [ linkContent "About" Pages.about ]
        , li [] [ linkContent "Watch me Elm Series" Pages.watchMeElm ]
        , li [] [ linkContent "Archives" Pages.archives ]
        ]


body : Model -> Html Msg
body model =
    section [ class "body" ]
        [ mainBody model, subContent ]


subContent : Html Msg
subContent =
    div [ class "subContent" ]
        [ p [] [ text "" ] ]


mainBody : Model -> Html Msg
mainBody model =
    div [ class "mainBody" ]
        [ h1 [] [ text model.currentContent.title ]
        , renderMeta model.currentContent
        , renderContent model
        ]


renderMeta : Content -> Html Msg
renderMeta content =
    case content.contentType of
        Types.Page ->
            div [] []

        Types.Post ->
            div [ class "content-meta" ]
                [ p []
                    [ text
                        ("Published on " ++ ViewHelpers.formatDate content.publishedDate ++ " by " ++ content.author.name ++ ".")
                    ]
                ]


convertMarkdownToHtml : WebData String -> Html Msg
convertMarkdownToHtml markdown =
    case markdown of
        Success data ->
            Markdown.toHtml [ class "markdown-content" ] data

        Failure e ->
            text "There was an error"

        _ ->
            text "Loading"


renderContent : Model -> Html Msg
renderContent model =
    case ViewSpecialCases.getSpecialCase model.currentContent.name of
        Just fn ->
            article [ class "fn-content" ] [ (fn model) ]

        Nothing ->
            renderMarkdown model.currentContent.markdown


renderMarkdown : WebData String -> Html Msg
renderMarkdown markdown =
    article [ class "markdown-content" ] [ convertMarkdownToHtml markdown ]


footer : Model -> Html Msg
footer model =
    Html.footer [ class "footer" ]
        [ renderContributors model.contributors ]


getContributorNames : List GithubContributor -> List (Html Msg)
getContributorNames contributors =
    contributors
        |> List.filter (\{ name } -> name /= "jackfranklin")
        |> List.map (\{ name, profileUrl } -> externalLink name profileUrl)
        |> List.intersperse (text ", ")


renderContributors : WebData (List GithubContributor) -> Html Msg
renderContributors contributors =
    case contributors of
        RemoteData.Success users ->
            p []
                ((text "The Elm Playground is created by Jack Franklin and contributors: ")
                    :: getContributorNames users
                )

        _ ->
            p [] []
