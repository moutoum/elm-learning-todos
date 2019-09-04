module Types exposing (..)

import Material


type alias Model =
    { input : String
    , todos : List String
    , mdc : Material.Model Msg
    }


type Msg
    = Mdc (Material.Msg Msg)
    | ChangeInput String
    | AddTodo
    | RemoveTodo Int
