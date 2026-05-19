import norm/[model, sqlite]
import mummy, mummy/routers
import logging
import strutils

var db {.threadvar.} : DbConn

# Internal function used to check whether the dbConn is active.
proc isAlive(dbConn: DbConn): bool =
  if dbConn.isNil:
    return false
  try:
    log(WARN, "Database connection not alive on a thread")
    dbConn.exec(sql"SELECT 1;")
    return true
  except CatchableError:
    return false

proc getDb*(): DbConn =
  if not isAlive(db):
    try:
      if not db.isNil:
        try:
          db.close()
        except:
          discard
      db = open("database.db", "", "", "")
      db.exec(sql"PRAGMA busy_timeout = 5000;")
      db.exec(sql"PRAGMA journal_mode = WAL;")
    except CatchableError as e:
      log(ERROR, @["Could not open/recover database: ", $e.msg].join(""))
  return db

type
  Account* = ref object of Model
    email*: string
    password*: string # Should be hashed securely before being stored

  Session* = ref object of Model
    token*: string
    expiresAt*: int64 # Unix Timestamp of expiration
    owner*: Account

proc newSession*(token: string, expiresAt: int64, owner: Account): Session =
  var session = Session(
    token: token,
    expiresAt: expiresAt,
    owner: owner
  )
  
  return session

proc newAccount*(email: string, password: string): Account =
  var account = Account(
    email: email,
    password: password
  )
  
  return account

proc hasAccountByEmail*(dbConn: DbConn, email: string): bool =
  return dbConn.exists(Account, "email = ?", email)
  
proc startupDb*() =
  log(DEBUG, "Database startup")
  var db : DbConn = getDb()
  db.createTables(Account())
  db.createTables(Session(owner: Account()))
  db.close # Don't know whether mummy uses the main thread for requests, so just closing it to reopen.
  db = nil # Set to nil so that, isNil check under getDb works without having to attempt an exec.
