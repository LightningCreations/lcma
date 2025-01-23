# Written by: Ayeon, 1/22/25
# Updated: 1/22/25

http = require('http')

# Configure Mock Code
# TODO Load these variables from conf.json

port = 8080
host = '127.0.0.1'

requestListener = (req, res) ->
    res.statusCode = 200
    res.setHeader 'Content-Type', 'text/plain'
    res.end 'Hello, World!\n'

server = http.createServer requestListener

server.listen port, host, ->
    console.log "Server is running on http://#{host}:#{port}"
