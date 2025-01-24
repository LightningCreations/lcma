# Written by: Ayeon, 1/22/25
# Updated: 1/22/25

http = require 'http'
fs = require 'fs'
querystring = require 'querystring'
crypto = require "crypto"

# Configure Mock Code
# TODO Load these variables from conf.json

port = 9060
host = '127.0.0.1'

formHtml = fs.readFileSync('build/form.html', 'utf8')
notFoundHtml = fs.readFileSync('html/404.html', 'utf8')
styleCss = fs.readFileSync('html/style.css', 'utf8')
clientJs = fs.readFileSync('build/frontend/client.js', 'utf8')

if !fs.existsSync('./db/')
    fs.mkdirSync './db/'

requestListener = (req, res) ->
    reqPath = req.url

    switch reqPath
        when '/'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/html'
            res.end formHtml
        when '/assets/client.js'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/css'
            res.end clientJs
        when '/assets/style.css'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/css'
            res.end styleCss
        when '/submit'
            if req.method is 'POST'
                body = ''
                req.on 'data', (chunk) -> body += chunk.toString()

                req.on 'end', ->
                    data = querystring.parse(body)
                    json = JSON.stringify data;


                    console.log 'Received data:', json



                    res.statusCode = 200
                    res.setHeader 'Content-Type', 'text/html'
                    res.end "Application successfully submitted"
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

# TODO i.e
# /view/RQ8HphbxN3pvWsog
