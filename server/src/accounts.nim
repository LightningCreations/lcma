import norm/sqlite
import mummy, mummy/routers
import std/[os, json, strutils]

import logging
import config
import models


let conf = getConfig()

import std/[sysrand, times]

proc generateTokenSecure(): string =
  var bytes = newSeq[byte](32)
  if urandom(bytes):
    for b in bytes:
      result.add(b.toHex().toLowerAscii)
  else:
    raise newException(ValueError, "Failed to generate token secure")
  

proc createSession*(dbConn: DbConn, account: Account): string =
  let token = generateTokenSecure()
  
  let durationInSeconds = 30 * 24 * 60 * 60
  let expiresTimestamp = getTime().toUnix() + durationInSeconds

  var session = [Session(
    token: token,
    expiresAt: expiresTimestamp,
    owner: account
  )]
  
  dbConn.insert(session)
  return token

proc registerHandler*(request: Request) =
  log(DEBUG, @["/api/v1/account/register", $request.httpMethod].join(" "))

  try:
    let body : JsonNode = parseJson(request.body)
    
    var headers: HttpHeaders
    headers["Content-Type"] = "application/json"

    if not body.contains("email"):
      request.respond(400, headers, $(%*{"Invalid Body": "Requires email"}))
    if not body.contains("password"):
      request.respond(400, headers, $(%*{"Invalid Body": "Requires password"}))

    let dbConn = models.getDb()

    if not hasAccountByEmail(dbConn, body["email"].getStr()):
      log(DEBUG, @["Register account", $body["email"].getStr()].join(""))

      var account = [newAccount(body["email"].getStr(), body["password"].getStr())]
      dbConn.insert(account)
      
      var session = createSession(dbConn, account[0])
      request.respond(200, headers, $(%*{"status": "Account created", "sessionToken": session}))
      return

    request.respond(200, headers, $(%*{"status": "Account already exists"}))
  except JsonParsingError as e:
    var headers: HttpHeaders
    headers["Content-Type"] = "application/json"
    request.respond(400, headers, $(%*{"error": "Invalid Json in body", "details": e.msg}))
