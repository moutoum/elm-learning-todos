module Model exposing (..)

import Http
import Json.Decode exposing (Decoder, field, int, list, map2, string)
import Material
import Types exposing (Model, Msg(..), Todo)


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , todos = []
      , error = Nothing
      , mdc = Material.defaultModel
      }
    , Cmd.batch
        [ Material.init Mdc
        , Http.get
            { url = "http://localhost:8000/api/todos"
            , expect = Http.expectJson ReceiveTodos todosDecoder
            }
        ]
    )


todoDecoder : Decoder Todo
todoDecoder =
    map2 Todo
        (field "id" int)
        (field "value" string)


todosDecoder : Decoder (List Todo)
todosDecoder =
    list todoDecoder
