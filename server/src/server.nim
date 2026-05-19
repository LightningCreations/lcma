import mummy, mummy/routers
import std/[os, json, strutils]

import logging
include config

proc statusHandler(request: Request) =
  var headers: HttpHeaders
  headers["Content-Type"] = "text/plain"
  request.respond(200, headers, pretty(%*{"version" : 1, "status": "online"}))

var router: Router
router.get("/api/v1/status", statusHandler)

let server = newServer(router)
let config = getConfig()

log(INFO, @["Serving on http://localhost:", $config.port].join(""))

server.serve(Port(config.port))
