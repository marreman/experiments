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

    putStrLn $ show arguments

    let dockerComposeFile = currentDirectory </> "docker-compose.yml"
        dockerComposeFileTemp = currentDirectory </> "docker-compose.temp.yml"
        dockerComposeFileTemplate = currentDirectory </> "docker-compose.yml.template"

    dockerComposeFileExists <- fileExist dockerComposeFile
        
    case arguments of
        arg:image:subCommand ->
            if arg == "-i" then do
                putStrLn $ "Image: " ++ image
                putStrLn $ "Command: " ++ (show subCommand)

                template <- readFile dockerComposeFileTemplate

                let replaceImage = T.replace "IMAGE" $ T.pack image
                    replaceWorkingDir = T.replace "WORKING_DIR" $ T.pack currentDirectory
                    tempFile = (replaceImage . replaceWorkingDir) $ T.pack template
                    commandArgs = ["-f", dockerComposeFileTemp, "run", "app"] ++ subCommand

                _ <- writeFile dockerComposeFileTemp $ T.unpack tempFile
                _ <- callProcess "docker-compose" commandArgs

                return ()
            else
                putStrLn howToUseInfo
        _ -> 
            if dockerComposeFileExists then do
                _ <- createProcess $ shell "docker-compose run app $@"
                exitSuccess
            else
                putStrLn howToUseInfo

howToUseInfo :: String
howToUseInfo =
    unlines
        [ ""
        , "When no local docker-compose.yml is present you need to specify what Docker image to run using the -i flag:"
        , ""
        , "  run -i elixir mix new my-app"
        , "  run -i node:9.8.0 node my-script.js"
        , ""
        , "Instead of:"
        , ""
        , "  run mix new my-app"
        , "  run node my-script.js"
        ]
