module Update exposing (..)

import Material
import Types exposing (Model, Msg(..), Todo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        ChangeInput str ->
            ( { model | input = str }, Cmd.none )

        AddTodo ->
            ( { model
                | input = ""
                , todos = model.todos ++ [ Todo 0 model.input ]
              }
            , Cmd.none
            )

        RemoveTodo i ->
            let
                before =
                    List.take i model.todos

                after =
                    List.drop (i + 1) model.todos
            in
            ( { model | todos = before ++ after }, Cmd.none )

        ReceiveTodos result ->
            case result of
                Ok todos ->
                    ( { model | todos = todos }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Cannot fetch todo list" }, Cmd.none )
