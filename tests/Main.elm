port module Main exposing (..)

import ContentUtilsTests
import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)


main : TestProgram
main =
    run emit ContentUtilsTests.all


port emit : ( String, Value ) -> Cmd msg
