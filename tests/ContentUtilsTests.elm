module ContentUtilsTests exposing (..)

import Test exposing (..)
import Expect
import Types exposing (ContentType(..))
import ContentUtils exposing (..)
import Date
import RemoteData exposing (..)
import Pages


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
                    Expect.equal 0 <| List.length <| filterByContentType [] Page
            , test "No content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 0 <| List.length <| filterByContentType content Page
            , test "Just one content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Page }, { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 1 <| List.length <| filterByContentType content Page
            , test "Two content of that ContentType" <|
                \() ->
                    let
                        content =
                            [ { mockContent | contentType = Page }, { mockContent | contentType = Post }, { mockContent | contentType = Post } ]
                    in
                        Expect.equal 2 <| List.length <| filterByContentType content Post
            ]
        , describe "filterByTitle" <|
            [ test "Filter with Nothing" <|
                \() ->
                    let
                        content =
                            [ { mockContent | publishedDate = Date.fromTime 4 }
                            , { mockContent | publishedDate = Date.fromTime 1 }
                            , { mockContent | publishedDate = Date.fromTime 0 }
                            , { mockContent | publishedDate = Date.fromTime 3 }
                            , { mockContent | publishedDate = Date.fromTime 2 }
                            ]
                    in
                        Expect.equal (sortByDate content) (filterByTitle content Nothing)
            , test "Filter with an empty string" <|
                \() ->
                    let
                        content =
                            [ { mockContent | title = "Gabriel is learning Elm" }
                            , { mockContent | title = "Just a title" }
                            , { mockContent | title = "Learning Elm (Part1)" }
                            , { mockContent | title = "Learning Elm (Part2)" }
                            , { mockContent | title = "It will be easy if you already know Haskell" }
                            ]
                    in
                        Expect.equal content (filterByTitle content (Just ""))
            , test "Filter with some title" <|
                \() ->
                    let
                        content =
                            [ { mockContent | title = "Gabriel is learning Elm" }
                            , { mockContent | title = "Just a title" }
                            , { mockContent | title = "Learning Elm (Part1)" }
                            , { mockContent | title = "Learning Elm (Part2)" }
                            , { mockContent | title = "It will be easy if you already know Haskell" }
                            ]

                        expected =
                            [ { mockContent | title = "Gabriel is learning Elm" }
                            , { mockContent | title = "Learning Elm (Part1)" }
                            , { mockContent | title = "Learning Elm (Part2)" }
                            ]
                    in
                        Expect.equal expected (filterByTitle content (Just "Elm"))
            ]
        , describe "latest" <|
            [ test "latest of an empty content" <|
                \() ->
                    Expect.equal Pages.notFoundContent (latest [])
            , test "latest of one element content" <|
                \() ->
                    let
                        content =
                            [ mockContent ]
                    in
                        Expect.equal mockContent (latest content)
            , test "latest of two element content" <|
                \() ->
                    let
                        first =
                            { mockContent | title = "first", publishedDate = Date.fromTime 0 }

                        second =
                            { mockContent | title = "second", publishedDate = Date.fromTime 50 }

                        third =
                            { mockContent | title = "second", publishedDate = Date.fromTime 100 }

                        content =
                            [ first, third, second ]
                    in
                        Expect.equal third (latest content)
            ]
        , describe "sortByDate" <|
            [ test "sort empty content" <|
                \() ->
                    Expect.equal [] (sortByDate [])
            , test "sort content with different publication dates" <|
                \() ->
                    let
                        content =
                            [ { mockContent | publishedDate = Date.fromTime 4 }
                            , { mockContent | publishedDate = Date.fromTime 1 }
                            , { mockContent | publishedDate = Date.fromTime 0 }
                            , { mockContent | publishedDate = Date.fromTime 3 }
                            , { mockContent | publishedDate = Date.fromTime 2 }
                            ]

                        expected =
                            List.map Date.fromTime [ 4, 3, 2, 1, 0 ]
                    in
                        Expect.equal expected (List.map .publishedDate (sortByDate content))
            ]
        ]
