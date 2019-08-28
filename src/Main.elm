module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { input : String
    , todos : List String
    }


type Msg
    = ChangeInput String
    | AddTodo


init : Model
init =
    { input = ""
    , todos = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeInput str ->
            { model
                | input = str
            }

        AddTodo ->
            { model
                | input = ""
                , todos = model.todos ++ [ model.input ]
            }


view : Model -> Html Msg
view model =
    div []
        [ div [] <| List.map (div [] << List.singleton << text) model.todos
        , input [ placeholder "Enter a todo item", value model.input, onInput ChangeInput ] []
        , button [ onClick AddTodo ] [ text "Add" ]
        ]
