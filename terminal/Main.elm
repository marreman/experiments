module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


main : Html msg
main =
    tmux <| div [] [ text "test" ]


tmux : Html msg -> Html msg
tmux content =
    let
        topPane =
            div
                [ style
                    [ "height" => "60%"
                    ]
                ]
                []

        bottomPane =
            div
                [ style
                    [ "height" => "40%"
                    ]
                ]
                [ div
                    [ style
                        [ "height" => "1px"
                        , "width" => "100%"
                        , "position" => "relative"
                        , "backgroundColor" => colors.lightBlack
                        ]
                    ]
                    [ div
                        [ style
                            [ "width" => "50%"
                            , "height" => "100%"
                            , "position" => "absolute"
                            , "backgroundColor" => colors.white
                            ]
                        ]
                        []
                    ]
                ]

        bar =
            div
                [ style
                    [ "width" => "100%"
                    , "marginTop" => "auto"
                    , "backgroundColor" => colors.lightBlack
                    , "padding" => "0 4px"
                    ]
                ]
                [ text "nvim" ]
    in
        div
            [ style
                [ "height" => "100%"
                , "backgroundColor" => colors.background
                , "color" => colors.foreground
                , "fontFamily" => "monospace"
                , "fontSize" => "16px"
                , "display" => "flex"
                , "flexDirection" => "column"
                , "lineHeight" => "1.6"
                ]
            ]
            [ content
            , topPane
            , bottomPane
            , bar
            ]


colors =
    { background = "#2c2734"
    , foreground = "#efe9fe"
    , black = "#2c2734"
    , red = "#fe5d9d"
    , green = "#b1fe7d"
    , yellow = "#fec38e"
    , blue = "#68a6fe"
    , magenta = "#cab1fa"
    , cyan = "#7bfdff"
    , white = "#595266"
    , lightBlack = "#342f3c"
    , lightRed = "#ff5d9e"
    , lightGreen = "#b1fe7e"
    , lightYellow = "#fdc28d"
    , lightBlue = "#68a7ff"
    , lightMagenta = "#c9b0f9"
    , lightCyan = "#7bfdff"
    , lightWhite = "#f0eaff"
    }
