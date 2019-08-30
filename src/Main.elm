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
    | RemoveTodo Int


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

        RemoveTodo i ->
            let
                before =
                    List.take i model.todos

                after =
                    List.drop (i + 1) model.todos
            in
            { model
                | todos = before ++ after
            }


view : Model -> Html Msg
view model =
    div [ class "todos" ]
        [ div [] <| List.indexedMap viewTodo model.todos
        , div [ class "input" ]
            [ input [ placeholder "Enter a todo item", value model.input, onInput ChangeInput ] []
            , button [ onClick AddTodo ] [ text "Add" ]
            ]
        ]


viewTodo : Int -> String -> Html Msg
viewTodo index value =
    div [ class "todo" ]
        [ div [] [ text value ]
        , button [ onClick <| RemoveTodo index ] [ text "X" ]
        ]
