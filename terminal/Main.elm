module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Regex


flatten : List (List a) -> List a
flatten =
    List.foldr (++) []


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


syntaxHighlight : String -> Html msg
syntaxHighlight code =
    code
        |> String.lines
        |> List.map lineToNodes
        |> List.intersperse [ br [] [] ]
        |> flatten
        |> pre
            [ style
                [ "margin-top" => "0"
                , "margin-bottom" => "0"
                ]
            ]


vim : Html msg
vim =
    div [ style [ "display" => "flex" ] ]
        [ div [ style [ "width" => "40%" ] ]
            [ syntaxHighlight """
color : String -> String -> Html msg
color c s =
    span [ style [ "color" => c ] ] [ text s ]


main : Html msg
main =
    tmux
     """
            ]
        , div [ style [ "width" => "60%" ] ]
            [ syntaxHighlight """
pre [ style [] ]
    [ content
        |> String.lines
        |> List.indexedMap (\\line -> "  " ++ toString (nr + 1) ++ " " ++ line)
        |> String.join ""
        |> text
    ]
     """
            ]
        ]


lineToNodes : String -> List (Html msg)
lineToNodes line =
    line
        |> String.split " "
        |> List.map wordToNodes
        |> flatten
        |> List.intersperse (text " ")


wordToNodes : String -> List (Html msg)
wordToNodes word =
    let
        symbol =
            Regex.regex "\\[|\\]|\\|>|\\+|->|=>|=|:"

        string =
            Regex.regex "\""

        number =
            Regex.regex "\\d"
    in
        [ if Regex.contains symbol word then
            color colors.magenta word
          else if Regex.contains string word then
            color colors.green word
          else if Regex.contains number word then
            color colors.blue word
          else
            text word
        ]


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
            , bottomPane (pre [] [ text """
~/dev/experiments/callbag-location master
$ l
.cache
dist
node_modules
src
.gitignore
package-lock.json
package.json

~/dev/experiments/callbag-location master
$""" ])
            , bar
            ]
