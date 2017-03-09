module ContentUtilsTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (ContentType(..))
import ContentUtils exposing (..)
import Date
import RemoteData exposing (..)


mockString : String
mockString =
    "whatever"


mockAuthor : Types.Author
mockAuthor =
    { name = mockString
    , avatar = mockString
    }


mockContent : Types.Content
mockContent =
    { title = mockString
    , name = mockString
    , slug = mockString
    , publishedDate = Date.fromTime 0
    , author = mockAuthor
    , markdown = NotAsked
    , contentType = Page
    , intro = mockString
    }


all : Test
all =
    describe "ContentUtils test suite"
        [ describe "findBySlug"
            [ test "Empty content" <|
                \() ->
                    let
                        content =
                            []

                        expected =
                            Nothing

                        actual =
                            findBySlug content "whatever"
                    in
                        Expect.equal expected actual
            , test "Just one element" <|
                \() ->
                    let
                        post =
                            { mockContent | slug = "slug" }

                        content =
                            [ post ]

                        expected =
                            Just post

                        actual =
                            findBySlug content "slug"
                    in
                        Expect.equal expected actual
            , test "Slug not in the content" <|
                \() ->
                    let
                        post =
                            { mockContent | slug = "slug" }

                        content =
                            [ post ]

                        expected =
                            Nothing

                        actual =
                            findBySlug content "not-in-content"
                    in
                        Expect.equal expected actual
            , test "Slug in the middle of the content" <|
                \() ->
                    let
                        p =
                            mockContent

                        content =
                            [ p, p, p, p, { p | slug = "slug" }, p ]

                        expected =
                            Just { p | slug = "slug" }

                        actual =
                            findBySlug content "slug"
                    in
                        Expect.equal expected actual
            ]
        ]
