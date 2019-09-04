module View exposing (..)

import Html exposing (Html, div, text)
import Material.Card as Card
import Material.Fab as Fab
import Material.LayoutGrid as LayoutGrid
import Material.List as Lists
import Material.Options exposing (css, onClick, onInput, styled)
import Material.TextField as TextField
import Material.Typography as Typography
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    Card.view [ css "max-width" "500px", css "margin" "24px" ]
        [ styled div
            [ css "padding" "1rem" ]
            [ styled Html.h3 [ Typography.title, css "margin" "0" ] [ text "To do list" ]
            , viewTodos model
            , LayoutGrid.view [ css "padding" "8px" ]
                [ LayoutGrid.cell [ LayoutGrid.span9 ] [ viewInput model ]
                , LayoutGrid.cell [ LayoutGrid.span3 ] [ viewAddButton model ]
                ]
            ]
        ]


viewInput : Model -> Html Msg
viewInput model =
    TextField.view Mdc
        "todo-input"
        model.mdc
        [ TextField.label "Task label"
        , TextField.value model.input
        , TextField.placeholder "Enter your task..."
        , TextField.fullwidth
        , onInput ChangeInput
        ]
        []


viewAddButton : Model -> Html Msg
viewAddButton model =
    Fab.view Mdc
        "add-button"
        model.mdc
        [ Fab.extended
        , Fab.icon "add"
        , Fab.label
        , onClick AddTodo
        ]
        [ text "Add" ]


viewTodos : Model -> Html Msg
viewTodos model =
    model.todos
        |> List.indexedMap viewTodo
        |> Lists.ul Mdc "todo-list" model.mdc [ Lists.nonInteractive ]


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
        , Lists.metaIcon [ onClick <| RemoveTodo index ] "clear"
        ]
