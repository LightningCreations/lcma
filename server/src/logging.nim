import std/[locks, strutils, strformat]

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
  
  when ord(level) >= ord(minLevel):
    acquire(logLock)
    try:
      echo "[" & $level & "] " & msg
    finally:
      release(logLock)
