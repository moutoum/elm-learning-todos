module Update exposing (..)

import Material
import Model exposing (Model, Msg(..), deleteTodo, getTodo, postTodo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        ChangeInput str ->
            ( { model | input = str }, Cmd.none )

        ReceiveTodo result ->
            case result of
                Result.Ok todo ->
                    ( { model | todos = model.todos ++ [ todo ], error = Nothing }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Cannot fetch todo" }, Cmd.none )

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
                Result.Ok id ->
                    ( { model | error = Nothing }, getTodo id )

                Err _ ->
                    ( { model | error = Just "Cannot post this todo" }, Cmd.none )

        DeleteTodo id ->
            ( model, deleteTodo id )

        DeletedTodo result ->
            case result of
                Result.Ok id ->
                    ( { model
                        -- Remove the current id from the list
                        -- List.filter (\todo -> todo.id /= id) model.todos
                        | todos = (List.filter <| .id >> (/=) id) model.todos
                        , error = Nothing
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | error = Just "Cannot delete this todo" }, Cmd.none )
