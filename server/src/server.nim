import mummy, mummy/routers
import std/[os, json, strutils]

import logging
include config

proc statusHandler(request: Request) =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  request.respond(200, headers, $(%*{"version" : 1, "status": "online"})) # Probably should be calculated outside this API call

proc registerHandler(request: Request) =
  log(DEBUG, @["/api/v1/account/register", $request.httpMethod].join(" "))

  try:
    let body : JsonNode = parseJson(request.body)
    
    var headers: HttpHeaders
    headers["Content-Type"] = "application/json"

    if not body.contains("email"):
      request.respond(400, headers, $(%*{"Invalid Body": "Requires email"}))
    if not body.contains("password"):
      request.respond(400, headers, $(%*{"Invalid Body": "Requires password"})) 

    log(DEBUG, $body["email"])
    log(DEBUG, $body["password"])

    request.respond(200, headers, $(%*{"status": "success"}))
  except JsonParsingError as e:
    var headers: HttpHeaders
    headers["Content-Type"] = "application/json"

    request.respond(400, headers, $(%*{"error": "Invalid Json in body", "details": e.msg}))

var router: Router
router.get("/api/v1/status", statusHandler)
router.post("/api/v1/account/register", registerHandler)

let server = newServer(router)
let config = getConfig()

log(INFO, @["Serving on http://localhost:", $config.port].join(""))

server.serve(Port(config.port))
