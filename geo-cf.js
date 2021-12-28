// Based on https://developers.cloudflare.com/workers/examples/geolocation-hello-world
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  let html_content = ""
  let html_style = "body{padding:6em; font-family: sans-serif;} h1{color:#f6821f}"

  html_content += "<p> IP: " + request.headers.get("CF-Connecting-IP") + "</p>"
  html_content += "<p> Country: " + request.cf.country + "</p>"
  html_content += "<p> City: " + request.cf.city + "</p>"
  html_content += "<p> Timezone: " + request.cf.timezone + "</p>"


  let html = `
<!DOCTYPE html>
<body>
  <head>
    <title> Geolocation: Cloudflare </title>
    <style> ${html_style} </style>
  </head>
  <h1>Geolocation: Cloudflare</h1>
  <p>User GEO info based on CF info:</p>
  ${html_content}
</body>`

  return new Response(html, {
    headers: {
      "content-type": "text/html;charset=UTF-8",
    },})
}
