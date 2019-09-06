module Model exposing (..)

import Http exposing (emptyBody)
import Json.Decode exposing (Decoder, andThen, fail, field, int, list, map, map2, string, succeed, value)
import Json.Encode as Encode
import Material
import Url.Builder as UrlBuilder exposing (QueryParameter)


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
    | DeleteTodo Int
    | ReceiveTodos (Result Http.Error (List Todo))
    | PostedTodo (Result Http.Error Transaction)
    | DeletedTodo (Result Http.Error Transaction)


type Transaction
    = Ok
    | Error String


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , todos = []
      , error = Nothing
      , mdc = Material.defaultModel
      }
    , Cmd.batch
        [ Material.init Mdc
        , getTodos
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


transactionDecoder : Decoder Transaction
transactionDecoder =
    field "status" string
        |> andThen
            (\status ->
                case status of
                    "ok" ->
                        succeed Ok

                    "error" ->
                        map Error
                            (field "text" string)

                    _ ->
                        fail "invalid status"
            )


paramUrl : List String -> List QueryParameter -> String
paramUrl path params =
    UrlBuilder.absolute ([ "api" ] ++ path) params


url : List String -> String
url path =
    paramUrl path []


getTodos : Cmd Msg
getTodos =
    Http.get
        { url = url [ "todos" ]
        , expect = Http.expectJson ReceiveTodos todosDecoder
        }


postTodo : String -> Cmd Msg
postTodo value =
    Http.post
        { url = url [ "todo" ]
        , body = Http.jsonBody <| Encode.object [ ( "value", Encode.string value ) ]
        , expect = Http.expectJson PostedTodo transactionDecoder
        }


deleteTodo : Int -> Cmd Msg
deleteTodo id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url [ "todo", String.fromInt id ]
        , body = emptyBody
        , expect = Http.expectJson DeletedTodo transactionDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
