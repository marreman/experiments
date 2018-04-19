module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


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


color : String -> String -> Html msg
color c s =
    span [ style [ "color" => c ] ] [ text s ]


main : Html msg
main =
    tmux


nr : Int -> Html msg
nr n =
    n
        |> toString
        |> String.append "  "
        |> (flip String.append) " "
        |> text
        |> List.singleton
        |> span
            [ style
                [ "color" => colors.white
                , "verticalAlign" => "middle"
                ]
            ]


tabs : Int -> Html msg
tabs n =
    n
        * 4
        |> flip String.repeat " "
        |> text


vimContents : List (List (Html msg))
vimContents =
    [ [ nr 1
      , text "pre [ style [] ]"
      ]
    , [ nr 2
      , tabs 1
      , color colors.magenta "["
      , text " content"
      ]
    , [ nr 3
      , tabs 2
      , text "|> String.lines"
      ]
    , [ nr 4
      , tabs 2
      , text "|> List.indexedMap (\\nr line -> \"  \" ++ toString (nr + 1) ++ \" \" ++ line)"
      ]
    , [ nr 5
      , tabs 2
      , color colors.magenta "|>"
      , text " String.join \"\""
      ]
    , [ nr 6
      , tabs 2
      , color colors.magenta "|>"
      , text " text"
      ]
    , [ nr 7
      , tabs 1
      , color colors.magenta "]"
      ]
    ]


vim : Html msg
vim =
    vimContents
        |> List.intersperse ([ br [] [] ])
        |> List.foldr (++) []
        |> pre []


tmux : Html msg
tmux =
    let
        topPane topPaneContent =
            div
                [ style
                    [ "height" => "60%"
                    ]
                ]
                [ topPaneContent ]

        bottomPane content =
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
                , content
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
                , "lineHeight" => "1.3"
                ]
            ]
            [ topPane vim
            , bottomPane (text "")
            , bar
            ]
