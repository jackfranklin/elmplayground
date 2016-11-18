When setting out to start blogging about Elm I had the choice to use a static site generator, such as Jekyll, or be a bit more adventurous and build it from scratch. This gave me a great opportunity to use Elm on a slightly larger project than I had done before, and I made the decision to build the site entirely in Elm.

This approach has some downsides, mainly a reliance on JavaScript, which is not ideal for a blog, but given the subject matter and the target audience I decided it was a worthwhile trade off. When Elm does support server side rendering, I should be able to remedy this.

The code is also entirely [on GitHub][repo] if you'd like to check it out, and any pull requests are welcome! 

## Modelling the problem

As with any Elm project I started by defining my types. The site primarily works around pieces of content, in the form of `Page`s and `Post`s. These are defined by the union type `ContentType`, and these form part of the `Content` type:

```elm
type alias Content =
    { title : String
    , name : String
    , slug : String
    , publishedDate : Date
    , author : Author
    , markdown : WebData String
    , contentType : ContentType
    , intro : String
    }
```

Here, an `Author` is a type alias to a record with a `name` and `avatar` property, and `WebData` comes from Kris Jenkin's excellent [RemoteData][remotedata] package, which I'll talk more about later.

The `Model` contains the current piece of content, which is the index page by default, and a list of all content pieces. However, given the list of all pieces is static and doesn't change, I've half a mind to take it out of the `Model` and just have a constant function defined.

## Urls

For routing I was able to avoid any of the heavier routing packages and use the [Elm  Navigation][navigation] package to update the URL and manage rendering the right content for the given URL. Every time the URL changes a `UrlChange` message is sent. This looks to find the matching piece of content for the given URL (or "slug"), and then sends off commands to fetch that content:

```elm
UrlChange newUrl ->
    let
        piece =
            ContentUtils.findBySlug model.allContent newUrl
    in
        case piece of
            Nothing ->
                ( model, Navigation.modifyUrl "/404" )

            Just item ->
                let
                    newItem =
                        { item | markdown = RemoteData.Loading }
                in
                    ( { model | currentContent = newItem }
                    , Cmd.batch
                        [ FetchContent.fetch newItem
                        , Title.setTitle newItem
                        ]
                    )
```

If we don't find a piece of content, the user is sent to the 404 page, else we start fetching the content, and we use the `Title` module to set the page's title property, which is done via a port.

## Fetching Content

For each piece of content, there is a corresponding Markdown file that contains the content. This makes an HTTP request to fetch the data, which is wrapped as a [RemoteData][remotedata] instance. This makes it really easy to handle errors loading files, and to also show when a piece of content is loading.

The content is parsed using [elm-markdown][elm-markdown], which also enables code highlighting via [highlight.js](https://highlightjs.org/). This is the same setup that's used on the Elm package site, so the syntax highlighting is the same on this site as it is on the package site.

## Plenty More

Over the next few weeks I'll be blogging more about how I created this site, the decisions I made and some more of the libraries I used on the way. I'll also be blogging other Elm tutorials, and also documenting the process of upgrading to Elm 0.18 when the time comes.

If you'd like to play with the site, it's entirely openly [available on GitHub][repo], and there's a bunch of issues with tasks to do if you're feeling particularly eager.

If you have any questions you can [raise an issue on GitHub][repo] or [find me on Twitter](http://twitter.com/jack_franklin), I'd love to hear your thoughts.

[repo]: https://github.com/jackfranklin/elmplayground
[remotedata]: http://package.elm-lang.org/packages/krisajenkins/remotedata/latest
[navigation]: https://github.com/elm-lang/navigation
[elm-markdown]: https://github.com/evancz/elm-markdown
