module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode


type alias Marker =
    { latitude : Float
    , longitude : Float
    }


main : Html msg
main =
    text "map"



-- viewMap [ Marker 37.78 -122.4 ]


viewMap : List Marker -> Html msg
viewMap markers =
    node "google-map"
        [ property "fit-to-markers" <| Encode.string "true"
        , property "api-key" <| Encode.string "AIzaSyD3E1D9b-Z7ekrT3tbhl_dy8DCXuIuDDRc"
        ]
    <|
        List.map
            (\marker ->
                node "google-map-marker"
                    [ property "latitude" <| Encode.string <| toString marker.latitude
                    , property "longitude" <| Encode.string <| toString marker.longitude
                    ]
                    []
            )
            markers
