Something that continually trips beginners up in Elm is dealing with JSON responses from a third party API. I think this is because it's a completely new concept to those picking up Elm from JavaScript. It certainly took me a long time to get comfortable with Elm.

__Update on 18/11/16: Code updated to Elm 0.18__

Today, in the first post in a series, we'll look at using JSON decoders in Elm to deal with data from an API. I've purposefully made some of the data awkward to show some of the more complex parts of decoding JSON. Hopefully the APIs you're working with are much better than my fake one, but this post should have you covered if not!

Before we get into that though, let's go through the basics of Elm decoders.

## What is an Elm JSON decoder?

A decoder is a function that can take a piece of JSON and decode it into an Elm value, with a type that matches a type that Elm knows about. For example, if we have this JSON:

```js
{ "name": "Jack" }
```

Then I need to tell Elm that the value at the `name` field is a string, so it can parse the JSON value `"Jack"` and turn it into the Elm string `"Jack"`. Elm ships with many decoders for all of the built in types in Elm, and also the ability for us to make our own decoders, which is of more interest to us, as more often than not you'll be taking an object and converting it into an Elm record.

## Layering decoders

The real power of Elm's decoders, which is also why they can be pretty complicated to work with, is that you can combine them to make other decoders. This is something Brian Hicks wrote about in his [post on Elm decoders being like Lego](https://www.brianthicks.com/post/2016/10/17/composing-decoders-like-lego/), which I highly recommend reading. For example, Elm ships with a decoder for decoding an object with one field, called `JSON.Decode.map`. Its type signature is:

```elm
map: (a -> value) -> Decoder a -> Decoder value
```

What's important to remember is that all these decoder functions _return new decoders_. You have to layer the decoders together to match your JSON. In the case of `map`, its arguments are as follows:

- `(a -> value)` a function that will take the decoded value, and should return data of the type `value`, which is the Elm data you want to get out of your JSON.
- `Decoder a` is a decoder that can decode the given JSON and pull out a value of type `a`, which will be passed into the function given as the first argument.

For example, taking the JSON that we had earlier:

```js
{ "name": "Jack" }
```

Let's say we want to decode this into the following Elm record:

```elm
{ name = "Jack" }
```

The first step is to create our decoder. We're going to use `map`, because we want to decode a JSON object where we only care about one field. The JSON we're decoding could have _any number of fields_, but we use `map` because _we only care about one field_.

__Note__: through the following code examples I've imported the JSON decoding module as `import Json.Decode as Decode`, so I'll refer to functions as `Decode.map`, `Decode.string`, and so on.

First I'll define my decoder. The first argument is an object that takes the decoded value and turns it into the thing I want to end up with. The second is a decoder that can take a value at a particular field, and decode it. To do that I use `Decode.at`, which plucks an item out of the object and applies the given decoder to it:

```elm
userDecoder =
  map (\name -> { name = name })
    (Decode.at ["name"] Decode.string)
```

Before we go on, can you guess what the type of `userDecoder` is here?

It is:

```elm
userDecoder : Decode.Decoder { name : String }
```

Because it's a decoder that returns an Elm record with a `name` property of type `String`.

Now let's run this decoder and see what we get. We can run a decoder using `Decode.decodeString`, which takes a decoder and input. It returns an Elm result, which will be `Ok` if we were successful, or `Err` if we had an issue. Normally, if you're decoding HTTP responses and so on, you won't ever call this function manually, the library you're using will do it for you. It is really useful for testing decoders though!



__Note__: if you're more familiar with Elm decoding you might be aware of some extra Elm packages that exist to make JSON decoding easier. We'll cover those in a future tutorial; for now I'm sticking to the core Elm library only.

I can run my decoder like so:

```elm
Decode.decodeString userDecoder """{"name": "Jack"}"""
```

By wrapping the JSON input with three quotes on each side, I avoid having to escape the quotes in the JSON (three quotes is a multiline string in Elm where you can use double quotes without escaping them). This gives us back:

```elm
Ok { name = "Jack" }
```

Which is perfect, and exactly what we want!

## Type aliasing

It's pretty dull to have to repeat the type `{ name : String }` throughout this imaginary example, so I can instead type alias it:

```elm
type alias User = { name : String }
```

When you define a type alias in Elm, you not only get the alias but `User` is a constructor function:

```elm
User : String -> User
```

This means that I can call:

```elm
User "jack"
```

And get back:

```elm
{ name = "Jack" }
```

We can use this to our advantage. Recall that our `userDecoder` looks like so:

```elm
userDecoder : Decode.Decoder { name : String }
userDecoder =
    Decode.map (\name -> { name = name })
        (Decode.at [ "name" ] Decode.string)
```

Firstly, we can change the type annotation:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.map (\name -> { name = name })
        (Decode.at [ "name" ] Decode.string)
```

And then we can update the function that creates our `User`:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.map (\name -> User name)
        (Decode.at [ "name" ] Decode.string)
```

But whenever you have something of the form:

```elm
(\name -> User name)
```

Or, more generically:

```elm
(\x -> y x)
```

We can replace that by just passing the function we're calling directly, leaving us with the decoder:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.map User (Decode.at [ "name" ] Decode.string)
```

This is the most common pattern you'll see when dealing with decoding in Elm. The first argument to an object decoder is nearly always a constructor for a type alias. Just remember, it's a function that takes all the decoded values and turns them into the thing we want to end up with.

## Back to the problem at hand

Now we're a bit more familiar with decoders, let's look at our API and dealing with the data it gives us.

## The User Type

Our application is dealing with a `User` type that looks like so:

```elm
type alias User =
    { name : String
    , age : Int
    , description : Maybe String
    , languages : List String
    , playsFootball : Bool
    }
```

The only piece of data a user might be missing is `description`, which is why it's modelled as a `Maybe String`.

## The Data

Keeping in mind the above type we've got, here's the API response we're working with:

```javascript
{
  "users": [
    {
      "name": "Jack",
      "age": 24,
      "description": "A person who writes Elm",
      "languages": ["elm", "javascript"],
      "sports": {
        "football": true
      }
    },
    {
      "name": "Bob",
      "age": 25,
      "languages": ["ruby", "scala"],
      "sports": {}
    },
    {
      "name": "Alice",
      "age": 23,
      "description": "Alice sends secrets to Bob",
      "languages": ["C", "scala", "elm"],
      "sports": {
        "football": false
      }
    }
  ]
}
```

Immediately you should notice some important features of this response:

- All the data is nested under the `users` key
- Not every user has a `description` field.
- Every user has a `sports` object, but it doesn't always have the `football` key.

Granted, this example is a little extreme, but it's not that common to see APIs that have data like this. The good news is that if you have a nice, friendly, consistent API, then this blog post will hopefully still help, and you'll have less work!

When dealing with data like this, I like to start with the simplest piece of the puzzle and work up to the most complicated. Looking at the data we have, most of the fields are always present, and always of the same type, so let's start with that and ignore the rest of the fields.

Let's create the `userDecoder` that can decode a user object. We know we have five fields, so we can use `Decode.map5` to do that. The first argument we'll give it is the `User` type, which will be the function that constructs a user for us. We can easily decode the `name`  field, which is always a string:

```elm
userDecoder =
    Decode.map5
        User
        (Decode.at [ "name" ] Decode.string)
        -- more fields to come here
```

And we can do the same for `age`, which is an integer:

```elm
userDecoder =
    Decode.map5
        User
        (Decode.at [ "name" ] Decode.string)
        (Decode.at [ "age" ] Decode.int)
        -- other fields to come, hold tight!
```

And we can do the same for `languages`. `languages` is a list of strings, and we can decode that by using the `Decode.list` decoder, which takes another decoder which it will use for each individual item. So `Decode.list Decode.string` creates a decoder that can decode a list of strings:

```elm
userDecoder =
    Decode.map5
        User
        (Decode.at [ "name" ] Decode.string)
        (Decode.at [ "age" ] Decode.int)
        -- we'll decode the description field here in a mo
        (Decode.at [ "languages" ] (Decode.list Decode.string))
        -- we'll decode the sports object here in a mo
```

A top tip when you want to test decoders incrementally - you can use `Decode.succeed` to have a decoder pay no attention to the actual JSON and just succeed with the given value. So to finish our decoder we can simply fill in our missing fields with `Decode.succeed`:

```elm
userDecoder =
    Decode.map5
        User
        (Decode.at [ "name" ] Decode.string)
        (Decode.at [ "age" ] Decode.int)
        (Decode.succeed Nothing)
        (Decode.at [ "languages" ] (Decode.list Decode.string))
        (Decode.succeed False)
```

That makes our decoded `description` value always `Nothing` (recall that `description` is a `Maybe`), and our `playsFootball` value always `False`.

## Order of decoders

Something that I failed to realise early on when I was getting used to JSON decoding is why the decoders above are ordered as such. It's because they match the ordering of values in the `User` type alias.

Because the `User` fields are defined in this order:

```elm
type alias User =
    { name : String
    , age : Int
    , description : Maybe String
    , languages : List String
    , playsFootball : Bool
    }
```

We have to decode in that order, too.

## Decoding maybe values

If we have a key that is not always present, we can decode that with `Decode.maybe`. This takes another decoder, and if that decoder fails because the key it's looking for isn't present, it will be decoded to `Nothing`. Else, it will be decoded to `Just val`, where `val` is the value that was decoded.

What this means in practice is that to decode a `maybe` you simply write the decoder you would write if the field was always present, in our case:

```elm
(Decode.at [ "description" ] Decode.string)
```

And we then wrap it in `Decode.maybe`:

```elm
(Decode.maybe (Decode.at [ "description" ] Decode.string))
```

And that's it! We're now nearly done with our decoder:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.map5
        User
        (Decode.at [ "name" ] Decode.string)
        (Decode.at [ "age" ] Decode.int)
        (Decode.maybe (Decode.at [ "description" ] Decode.string))
        (Decode.at [ "languages" ] (Decode.list Decode.string))
        (Decode.succeed False) -- just this one to go!
```


## `Decode.map`

It's time to get a bit more complex and decode the sports object. Remember that we just want to pull out the `football` field, if it's present, but set it to `False` if it's not present.

The `sports` key will be one of three values:

- `{}`
- `{ "football": true }`
- `{ "football": false }`

And we use it to set the `playsFootball` boolean to `True` or `False`. In the case where the `football` key isn't set, we want to default it to `False`.

Before dealing with the case where it's missing, let's pretend it's always present, and see how we would decode that. We'd create a decoder that pulls out the `football` field, and decodes it as a boolean:

```elm
Decode.at [ "sports", "football" ] Decode.bool
```

That would pull out the `football` key in the `sports` object, and decode it as a boolean. However, we need to deal with the `football` key being missing. The first thing I'm going to do is define another decoder, `sportsDecoder`, which will take the `sports` object and decode it:

```elm
Decode.at [ "sports" ] sportsDecoder

sportsDecoder =
    Decode.at [ "football" ] Decode.bool
```

This is equivalent to the previous example but we've now split the code up a little. Remember earlier that we used `Decode.succeed` to make a JSON decoder succeed with a given value? That's what we need to use here. We effectively want to try to decode it first, but if it goes wrong, just return `False`. If we were writing our decoder out in English, we'd say:

1. Try to find the value in the `football` field and decode it as boolean.
2. If something goes wrong, don't worry about it, just set the value to `False`.

It turns out that Elm gives us `Decode.oneOf`, which does exactly that! `Decode.oneOf` takes a list of decoders and will try each of them in turn. If anything goes wrong it will try the next decoder in the list. Only if none of the decoders work will it fail.

So the first thing we can do is wrap our existing `sportsDecoder` in a `Decode.oneOf` call:

```elm
sportsDecoder =
    (Decode.oneOf
        [ Decode.at [ "football" ] Decode.bool ]
    )
```

That will work when the field is present, but now we need to cover the other case and always return `False`:

```elm
sportsDecoder =
    (Decode.oneOf
        [ Decode.at [ "football" ] Decode.bool
        , Decode.succeed False
        ]
    )
```

With that change, we decode the value if it exists, or we set it to `False`. We're done!

## Conclusion

I hope this article has gone some way to showing that Elm's decoding isn't quite as scary as it first seems. Yes, it's not always immediately intuitive, and takes time to get used to, but once you get the hang of it I think you'll find it really nice to be able to so explicitly deal with JSON and decode it into your application's types.

If you'd like to look at the code, I've [got a small app on Github](https://github.com/jackfranklin/elm-json-decoding) that uses the decoders in this article, and you can [find me on Twitter](http://twitter.com/Jack_Franklin) (or the Elm slack channel!) if you have any questions.
