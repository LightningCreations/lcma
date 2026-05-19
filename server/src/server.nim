import mummy, mummy/routers
import std/[json, strformat]

import logging
import config
import database

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

log(INFO, fmt"Serving on http://{conf.domain}:{$conf.port}")

server.serve(Port(conf.port))
