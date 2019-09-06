module Types exposing (..)

import Http
import Material


type alias Todo =
    { id : Int
    , value : String
    }


type alias Model =
    { input : String
    , todos : List Todo
    , error : Maybe String
    , mdc : Material.Model Msg
    }


type Msg
    = Mdc (Material.Msg Msg)
    | ChangeInput String
    | AddTodo
    | RemoveTodo Int
    | ReceiveTodos (Result Http.Error (List Todo))
