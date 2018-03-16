{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Data.Maybe
import qualified Data.Text as T
import System.Directory
import System.Exit
import System.Environment
import System.FilePath
import System.Posix.Files
import System.Process

main :: IO ()
main = do
    currentDirectory <- getCurrentDirectory
    arguments <- getArgs

    let dockerComposeFileTemp = currentDirectory </> "docker-compose.temp.yml"
        
    case arguments of
        image:commandToRunInImage -> do
            let replaceImage = T.replace "IMAGE" $ T.pack image
                replaceWorkingDir = T.replace "WORKING_DIR" $ T.pack currentDirectory
                tempFile = (replaceImage . replaceWorkingDir) $ T.pack dockerComposeFileTemplate
                commandArgs = ["-f", dockerComposeFileTemp, "run", "app"] ++ commandToRunInImage

            _ <- writeFile dockerComposeFileTemp $ T.unpack tempFile
            _ <- callProcess "docker-compose" commandArgs
            _ <- removeFile dockerComposeFileTemp

            return ()
        _ -> 
            putStrLn howToUseInfo

howToUseInfo :: String
howToUseInfo =
    unlines
        [ "Run a command in any Docker image with the current folder mounted."
        , ""
        , "Usage:"
        , "  run [IMAGE] [COMMAND_TO_RUN_IN_IMAGE]"
        , ""
        , "Examples:"
        , "  run elixir mix new my-app"
        , "  run node:9.8.0 node my-script.js"
        ]

dockerComposeFileTemplate :: String
dockerComposeFileTemplate =
    unlines
        [ "version: '3'"
        , "services:"
        , "  app:"
        , "    image: IMAGE"
        , "    working_dir: /app"
        , "    volumes:"
        , "      - WORKING_DIR:/app"
        ]
