Something that continually trips beginners up in Elm is dealing with JSON responses from a third party API. I think this is because it's a completely new concept to those picking up Elm from JavaScript. It certainly took me a long time to get comfortable with Elm.

Today, in the first post in a series, we'll look at using JSON decoders in Elm to deal with data from an API. I've purposefully made some of the data awkward to show some of the more complex parts of decoding JSON. Hopefully the APIs you're working with are much better than my fake one, but this post should have you covered if not!

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

## What is an Elm JSON decoder?

A decoder is a function that can take a piece of JSON and decode it into an Elm value, with a type that matches a type that Elm knows about. For example, if we have this JSON:

```js
{ "name": "Jack" }
```

Then I need to tell Elm that the value at the `name` field is a string, so it can parse the JSON value `"Jack"` and turn it into the Elm string `"Jack"`. Elm ships with many decoders for all of the built in types in Elm, and also the ability for us to make our own decoders, which is of more interest to us, as more often than not you'll be taking an object and converting it into an Elm record.

## Layering decoders

The real power of Elm's decoders, which is also why they can be pretty complicated to work with, is that you can combine them to make other decoders. This is something Brian Hicks wrote about in his [post on Elm decoders being like Lego](https://www.brianthicks.com/post/2016/10/17/composing-decoders-like-lego/), which I highly recommend reading. For example, Elm ships with a decoder for decoding an object with one field, called `JSON.Decode.object1`. Its type signature is:

```elm
object1: (a -> value) -> Decoder a -> Decoder value
```

What's important to remember is that all these decoder functions _return new decoders_. You have to layer the decoders together to match your JSON. In the case of `object1`, its arguments are as follows:

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

The first step is to create our decoder. We're going to use `object1`, because we want to decode a JSON object where we only care about one field. The JSON we're decoding could have _any number of fields_, but we use `object1` because _we only care about one field_.

__Note__: through the following code examples I've imported the JSON decoding module as `import Json.Decode as Decode`, so I'll refer to functions as `Decode.object1`, `Decode.string`, and so on.

First I'll define my decoder. The first argument is an object that takes the decoded value and turns it into the thing I want to end up with. The second is a decoder that can take a value at a particular field, and decode it. To do that I use `Decode.at`, which plucks an item out of the object and applies the given decoder to it:

```elm
userDecoder =
  object1 (\name -> { name = name })
    (Decode.at ["name"] Decode.string)
```

Before we go on, can you guess what the type of `userDecoder` is here?

It is:

```elm
userDecoder : Decode.Decoder { name : String }
```

Because it's a decoder that returns an Elm record with a `name` property of type `String`.

Now let's run this decoder and see what we get. We can run a decoder using `Decode.decodeString`, which takes a decoder and input. It returns an Elm result, which will be `Ok` if we were successful, or `Err` if we errored. Normally, if you're decoding HTTP responses and so on, you won't ever call this function manually, the library you're using will do it for you. It is really useful for testing decoders though!



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
    Decode.object1 (\name -> { name = name })
        (Decode.at [ "name" ] Decode.string)
```

Firstly, we can change the type annotation:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.object1 (\name -> { name = name })
        (Decode.at [ "name" ] Decode.string)
```

And then we can update the function that creates our `User`:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.object1 (\name -> User name)
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
    Decode.object1 User (Decode.at [ "name" ] Decode.string)
```

This is the most common pattern you'll see when dealing with decoding in Elm. The first argument to an object decoder is nearly always a constructor for a type alias.


