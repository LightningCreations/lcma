import std/locks

type
  LogLevel* = enum
    Debug = (0, "DEBUG")
    INFO  = (1, "INFO")
    WARN  = (2, "WARN")
    ERROR = (3, "ERROR")

const logLevel* {.strdefine.} = "DEBUG"

var logLock: Lock
initLock(logLock)

template log*(level: LogLevel, msg: string) =
  const minLevel : LogLevel = parseEnum[LogLevel](logLevel)
  
  when level >= minLevel:
    acquire(logLock)
    try:
      echo @["[", $level, "]", " ", msg].join("")
    finally:
      release(logLock)
