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
