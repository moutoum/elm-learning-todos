module Model exposing (..)

import Material
import Types exposing (Model, Msg(..))


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { input = ""
      , todos = []
      , mdc = Material.defaultModel
      }
    , Material.init Mdc
    )
