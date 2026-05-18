import std/[os, json, strutils]
type
  Config = object
    version: int
    port: int
    domain: string

# Returns a copy of the config, will generate a config is not found on the filesystem
proc getConfig(): Config =
  let dirPath = getHomeDir() / ".config" / "lcma"
  if dirExists(dirPath) != true:
    dirPath.createDir()

  let path = dirPath / "config.json"
  let exists = fileExists(path)

  var config : Config

  if exists:
    try:
      let configJson = parseFile(path)
      config = to(configJson, Config)
    except JsonParsingError as e:
      echo e.msg
  else:
    config = Config(version: 1, port: 8000, domain: "localhost")

    let configJson = %config
    
    try:
      syncio.writeFile(path, pretty(configJson))
    except IOError as e:
      echo e.msg
    
  return config
