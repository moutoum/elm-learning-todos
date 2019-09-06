module Subscriptions exposing (..)

import Material
import Model exposing (Model, Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model
