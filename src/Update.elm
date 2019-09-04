module Update exposing (..)

import Material
import Types exposing (Model, Msg(..))


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
                , todos = model.todos ++ [ model.input ]
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
