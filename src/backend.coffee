# Written by: Ayeon, 1/22/25
# Updated: 1/22/25

http = require('http')
fs = require 'fs'
querystring = require 'querystring'

# Configure Mock Code
# TODO Load these variables from conf.json

port = 8080
host = '127.0.0.1'

formHtml = fs.readFileSync('html/form.html', 'utf8')
notFoundHtml = fs.readFileSync('html/404.html', 'utf8')

requestListener = (req, res) ->
    reqPath = req.url

    switch reqPath
        when '/'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/html'
            res.end formHtml
        when '/submit'
            if req.method is 'POST'
                body = ''
                req.on 'data', (chunk) -> body += chunk.toString()

                req.on 'end', ->
                    data = querystring.parse(body)
                    console.log 'Received data:', data
                    res.statusCode = 200
                    res.setHeader 'Content-Type', 'application/json'
                    res.end '{"message":"Data received successfully"}'
            else
                res.statusCode = 302
                res.setHeader 'Location', '/'
                res.end()
        else
            res.statusCode = 404
            res.setHeader 'Content-Type', 'text/html'
            res.end notFoundHtml

server = http.createServer requestListener

server.listen port, host, ->
    console.log "Server is running on http://#{host}:#{port}"
