module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, text)
import Material
import Material.Card as Card
import Material.Fab as Fab
import Material.LayoutGrid as LayoutGrid
import Material.List as Lists
import Material.Options as Options exposing (css, styled)
import Material.TextField as TextField
import Material.Typography as Typography


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


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


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , todos = []
      , mdc = Material.defaultModel
      }
    , Material.init Mdc
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


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


view : Model -> Html Msg
view model =
    Card.view [ css "max-width" "500px", css "margin" "24px" ]
        [ styled div
            [ css "padding" "1rem" ]
            [ styled Html.h3 [ Typography.title, css "margin" "0" ] [ text "To do list" ]
            , model.todos
                |> List.indexedMap viewTodo
                |> Lists.ul Mdc "todo-list" model.mdc [ Lists.nonInteractive ]
            , LayoutGrid.view [ css "padding" "8px" ]
                [ LayoutGrid.cell [ LayoutGrid.span9 ]
                    [ TextField.view Mdc
                        "todo-input"
                        model.mdc
                        [ TextField.label "Task label"
                        , TextField.value model.input
                        , TextField.placeholder "Enter your task..."
                        , TextField.fullwidth
                        , Options.onInput ChangeInput
                        ]
                        []
                    ]
                , LayoutGrid.cell [ LayoutGrid.span3 ]
                    [ Fab.view Mdc
                        "add-button"
                        model.mdc
                        [ Fab.extended
                        , Fab.icon "add"
                        , Fab.label
                        , Options.onClick AddTodo
                        ]
                        [ text "Add" ]
                    ]
                ]
            ]
        ]


viewTodo : Int -> String -> Lists.ListItem Msg
viewTodo index value =
    Lists.li []
        [ Lists.text []
            [ Lists.primaryText [] [ text value ]
            , Lists.secondaryText []
                [ index
                    |> String.fromInt
                    |> (++) "Item #"
                    |> text
                ]
            ]
        , Lists.metaIcon [ Options.onClick <| RemoveTodo index ] "clear"
        ]
