module Update exposing (..)

import Material
import Model exposing (Model, Msg(..), deleteTodo, getTodos, postTodo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        ChangeInput str ->
            ( { model | input = str }, Cmd.none )

        ReceiveTodos result ->
            case result of
                Result.Ok todos ->
                    ( { model | todos = todos, error = Nothing }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Cannot fetch todo list" }, Cmd.none )

        AddTodo ->
            ( { model | input = "" }, postTodo model.input )

        PostedTodo result ->
            case result of
                Result.Ok Model.Ok ->
                    ( { model | error = Nothing }, getTodos )

                Result.Ok (Model.Error text) ->
                    ( { model | error = Just text }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Cannot post this todo" }, Cmd.none )

        DeleteTodo id ->
            ( model, deleteTodo id )

        DeletedTodo result ->
            case result of
                Result.Ok Model.Ok ->
                    ( { model | error = Nothing }, getTodos )

                Result.Ok (Model.Error text) ->
                    ( { model | error = Just text }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Cannot delete this todo" }, Cmd.none )
