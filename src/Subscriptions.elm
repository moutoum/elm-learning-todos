module Subscriptions exposing (..)

import Material
import Types exposing (Model, Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model
