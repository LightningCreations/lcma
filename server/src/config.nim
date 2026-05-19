import std/[os, json, strutils]
import logging

type
  Config = object
    version: int
    port: int
    domain: string

# Returns a copy of the config, will generate a config is not found on the filesystem
proc getConfig(): Config =
  log(DEBUG, "Loading Config")
  
  let dirPath = getHomeDir() / ".config" / "lcma"
  if dirExists(dirPath) != true:
    log(DEBUG, "Creating config folder")
    dirPath.createDir()

  let path = dirPath / "config.json"
  let exists = fileExists(path)

  var config : Config

  if exists:
    try:
      log(DEBUG, "Config found, loading it")
      let configJson = parseFile(path)
      config = to(configJson, Config)
    except JsonParsingError as e:
      log(ERROR, e.msg)
  else:
    log(DEBUG, "Config not found, creating it")
    config = Config(version: 1, port: 8000, domain: "localhost")

    let configJson = %config
    
    try:
      syncio.writeFile(path, pretty(configJson))
    except IOError as e:
      log(ERROR, e.msg)

  log(DEBUG,  "Config successfully loaded")
  return config
