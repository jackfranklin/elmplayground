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
                    Expect.equal Nothing <| findBySlug [] "whatever"
            , test "Just one element" <|
                \() ->
                    let
                        post =
                            { mockContent | slug = "slug" }
                    in
                        Expect.equal (Just post) <| findBySlug [ post ] "slug"
            , test "Slug not in the content" <|
                \() ->
                    let
                        post =
                            { mockContent | slug = "slug" }
                    in
                        Expect.equal Nothing <| findBySlug [ post ] "not-in-content"
            , test "Slug in the middle of the content" <|
                \() ->
                    let
                        p =
                            mockContent

                        content =
                            [ p, p, p, p, { p | slug = "slug" }, p ]
                    in
                        Expect.equal (Just { p | slug = "slug" }) <| findBySlug content "slug"
            ]
        , describe "filterByContentType" <|
            -- I have the feeling that I've been testing the filter function, and I shouldn't
            [ test "Empty content" <|
                \() ->
                    Expect.equal 0 <| List.length <| filterByContentType Page []
            , test "No content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 0 <| List.length <| filterByContentType Page content
            , test "Just one content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Page }, { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 1 <| List.length <| filterByContentType Page content
            , test "Two content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Page }, { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 2 <| List.length <| filterByContentType Post content
            ]
        , describe "flipComparison" <|
            [ test "flipComparison of compare 1 2 should be GT" <|
                \() ->
                    Expect.equal GT <| flipComparison compare 1 2
            , test "flipComparison of compare 2 1 should be LT" <|
                \() ->
                    Expect.equal LT <| flipComparison compare 2 1
            , test "flipComparison of compare 1 1 should be EQ" <|
                \() ->
                    Expect.equal EQ <| flipComparison compare 1 1
            ]
        ]
