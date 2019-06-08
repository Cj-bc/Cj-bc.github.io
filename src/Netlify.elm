module Netlify exposing (netlify)

import Html
import VirtualDom


netlify : String -> Html.Attribute msg
netlify =
    VirtualDom.attribute "netlify"
