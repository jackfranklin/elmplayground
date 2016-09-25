module MyApp exposing (..)

import Html exposing (Html, text)
import Navigation
import Types exposing (Model, Msg(..))
import View
import Pages
import Posts


initialModel : Model
initialModel =
    { currentContent = Pages.index
    , contentPieces = Pages.pages ++ Posts.posts
    }


init : String -> ( Model, Cmd Msg )
init url =
    urlUpdate url initialModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    View.render model


toUrl : Model -> String
toUrl model =
    model.currentContent.slug


fromUrl : String -> String
fromUrl url =
    url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .pathname)


urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    ( model, Cmd.none )


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = always Sub.none
        }
