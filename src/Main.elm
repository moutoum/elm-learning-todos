module Main exposing (..)

import Browser
import Model exposing (init)
import Subscriptions exposing (subscriptions)
import Types exposing (Model, Msg)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
