import mummy, mummy/routers
import std/[os, json, strutils]

import norm/sqlite
import logging
import config
import models

import accounts

proc statusHandler(request: Request) =
  var headers: HttpHeaders
  headers["Content-Type"] = "application/json"
  request.respond(200, headers, $(%*{"version" : 1, "status": "online"})) # Probably should be calculated outside this API call

var router: Router

router.get("/api/v1/status", statusHandler)
router.post("/api/v1/account/register", registerHandler)

let server = newServer(router)
let conf = getConfig()

startupDb()

log(INFO, @["Serving on http://localhost:", $conf.port].join(""))

server.serve(Port(conf.port))
