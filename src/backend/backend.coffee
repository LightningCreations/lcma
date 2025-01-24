# Written by: Ayeon, 1/22/25
# Updated: 1/22/25


BSON = require 'bson'
http = require 'http'
fs = require 'fs'
querystring = require 'querystring'
crypto = require "crypto"

# Configure Mock Code
# TODO Load these variables from conf.json

port = 9060
host = '127.0.0.1'
sqliteLocation = "sqlite:///home/andi/Projects/LC/lcma/db.sqlite"

formHtml = fs.readFileSync('build/form.html', 'utf8')
formCss = fs.readFileSync('css/form.css', 'utf8')
viewCss = fs.readFileSync('css/view.css', 'utf8')
clientJs = fs.readFileSync('build/frontend/client.js', 'utf8')

if !fs.existsSync('./db/')
    fs.mkdirSync './db/'

{ KeyvSqlite } = require('@keyv/sqlite');
{ Keyv } = require('keyv');

keyvSqlite = new KeyvSqlite(sqliteLocation);
keyv = new Keyv({ store: keyvSqlite, namespace: 'cache' });

requestListener = (req, res) ->
    reqPath = req.url

    if reqPath.startsWith("/view?id=")
        res.statusCode = 200
        res.setHeader 'Content-Type', 'text/html'

        id = reqPath.split("?id=")[1].split('?')[0]

        keyv.get(id).then((bytes) -> # bson data
            data = BSON.deserialize(bytes)
            keys = Object.keys(data)
            html = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <link rel="stylesheet" href="/assets/view.css">
            </head>
            <body>
"""
            html += "<span class=\"results\">"
            keys.forEach (key) ->
                html += "<h2>" + key + "</h2>\n"
                html += "<p>" + data[key] + "</p>\n"
            html += """
            </span></body>
            <footer>
            <p>&copy; 2025 Lightning Creations. All rights reserved.</p>
            <p>This project is licensed under the BSD-3-Clause License, which can be found at <a href="https://opensource.org/license/BSD-3-clause">https://opensource.org/license/BSD-3-clause</a></p>
            <p>Made with ❤️ by Lightning Creations</p>
            </footer>
            </body>
            </html>
            """

            res.end html
            return
        ).catch (err) ->
            console.error 'Error retrieving value:', err
            return

        return

    switch reqPath
        when '/'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/html'
            res.end formHtml
        when '/assets/client.js'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/css'
            res.end clientJs
        when '/assets/form.css'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/css'
            res.end formCss
        when '/assets/view.css'
            res.statusCode = 200
            res.setHeader 'Content-Type', 'text/css'
            res.end viewCss
        when '/submit'
            if req.method is 'POST'
                body = ''
                req.on 'data', (chunk) -> body += chunk.toString()

                req.on 'end', ->
                    data = querystring.parse(body)
                    id = crypto.randomBytes(16).toString("hex")
                    bytes = BSON.serialize data

                    await keyv.set(id, bytes)

                    res.statusCode = 301
                    res.setHeader 'location', '/view?id=' + id
                    res.end()
            else
                res.statusCode = 302
                res.setHeader 'Location', '/'
                res.end()
        else
            res.statusCode = 302
            res.setHeader 'Location', '/'
            res.end()

server = http.createServer requestListener

server.listen port, host, ->
    console.log "Server is running on http://#{host}:#{port}"

# TODO i.e
# /view/RQ8HphbxN3pvWsog
