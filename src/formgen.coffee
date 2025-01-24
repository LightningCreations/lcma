fs = require('fs')
crypto = require "crypto"

console.info "Building HTML for Form"

html = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <script src="/assets/client.js"></script>
  <link rel="stylesheet" href="/assets/style.css">
</head>
<body>
<form action="/submit" method="post">
"""

data = fs.readFileSync './build/questions.json', 'utf8'
jsonData = JSON.parse(data)["questions"]

sCounter = 0


Object.keys(jsonData).forEach (key) ->
  question = jsonData[key]

  hashed = crypto.createHash('md5').update(question["question"], 'binary').digest 'base64'

  html += "<span class=\"section section-" + sCounter + "\">"

  html += "<p class=\"quest\">" + question["question"] + "</p>\n"

  if question["type"] == "text"
    html += "<input type=\"text\" id=\"" + hashed + "\" name=\"" + question["question"] + "\" required><br/>\n"

  if question["type"] == "email"
    html += "<input type=\"email\" id=\"" + hashed + "\" name=\"" + question["question"] + "\" required><br/>\n"

  if question["type"] == "radio"
    question["answers"].forEach (answer) ->
      html += "<input type=\"radio\" id=\"" + hashed + "\" name=\"" + question["question"] + "\" value=\"" + answer + "\">\n"
      html += "<label for=\"" + hashed + "\">" + answer + "</label><br/>\n"

  sCounter += 1
  html += "</span>"

html += """
<div class="checkbox-container">
<input type="checkbox" id="NDg4MDc2NjQ4NWRlNzgyMWRiMTM5NDAzOTVhOTEzYzg=" name="agree" required="">
<label for="NDg4MDc2NjQ4NWRlNzgyMWRiMTM5NDAzOTVhOTEzYzg=">I agree to the above disclaimers</label>
</div>
<input id="submit" type="submit" value="Submit">
<button id="next" type="button" style="display: none;">Next</button>
<button id="back" type="button" style="display: none;">Back</button>
</form>
<footer>
<p>&copy; 2025 Lightning Creations. All rights reserved.</p>
<p>This project is licensed under the BSD-3-Clause License, which can be found at <a href="https://opensource.org/license/BSD-3-clause">https://opensource.org/license/BSD-3-clause</a></p>
<p>Made with ❤️ by Lightning Creations</p>
</footer>
</body>
</html>
"""

fs.writeFileSync './build/form.html', html
console.info "Writing Html to File"
