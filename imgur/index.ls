window.imgur = ->
  params = do ->
    part = /([^&=]+)=([^&]*)/g
    hash = location.hash.slice 1
    data = {}
    while m = part.exec hash
      [, key, value] = m.map decodeURIComponent
      data[key] = value
    data

  headers = Authorization: "Bearer #{params.access_token}"

  params: params
  call: (args) ->
    endpoint = args.endpoint || args
    url = "https://api.imgur.com/3/#endpoint"
    options = {headers}

    if args.data
      body = new FormData
      for key, value of that
        body.append key, value
      options <<< method: \POST body

    fetch url, options .then (.json!)

  list-albums: ->
    if params.account_username
      @call "account/#that/albums"
    else
      Promise.resolve []

  upload: ->
    data =
      image: it
      album: $ \#album .val!
      name: /\/([^/]+)$/exec it ?.1
    @call {endpoint: \image data}

<- $
client-id = $ \#client-id .val!
$ \#client-id .on \change ->
  client-id := @value
  $ \#login .attr \href "https://api.imgur.com/oauth2/authorize?client_id=#client-id&response_type=token"
.trigger \change

q = queue!
session = window.imgur!

handle-url = (url) ->
  status = $ \<div>
  $ \#status .append status
  status.text "waiting: #url"
  q.add ->
    status.text "uploading: #url"
    session.upload url
  .then ->
    status.text "done: #url"

handle-paste = (event) ->
  event.preventDefault!
  event.clipboardData.getData \text .split \\n
  .forEach handle-url

session.list-albums!then ({data: albums}) ->
  return if albums.length < 1
  $ \#album .empty!prepend albums.map ({title, id}) ->
    $ \<option> .text title .attr \value id

document.querySelector \#urls .addEventListener \paste handle-paste

fetch \README.md .then (.text!) .then ->
  $ \#readme .html marked it
