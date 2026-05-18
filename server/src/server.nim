import mummy, mummy/routers
import std/[os, json, strutils]

include config

proc indexHandler(request: Request) =
  var headers: HttpHeaders
  headers["Content-Type"] = "text/plain"
  request.respond(200, headers, "Hello, World!")

var router: Router
router.get("/", indexHandler)

let server = newServer(router)
let config = getConfig()

echo @["Serving on http://localhost:", $config.port].join("")

server.serve(Port(config.port))
