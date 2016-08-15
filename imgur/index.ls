<- $
client-id = \4a5fbf26fd7ce29
params = do ->
  p = /([^&=]+)=([^&]*)/g
  hash = location.hash.slice 1
  data = {}
  while m = p.exec hash
    [, key, value] = m.map decodeURIComponent
    data[key] = value
  data

headers = Authorization: "Bearer #{params.access_token}"
list-albums = ->
  url = "https://api.imgur.com/3/account/#{params.account_username}/albums"
  fetch url, {headers} .then (.json!)

upload-url = ->
  data =
    image: it
    album: $ \#album .val!
    type: \URL
    name: /\/([^/]+)$/exec it ?.1

  body = new FormData
  for key, value of data
    body.append key, value

  fetch \https://api.imgur.com/3/image {method: \POST body, headers}
  .then (.json!)

q = queue!

handle-url = (url) ->
  status = $ \<div>
  $ \#status .append status
  status.text "waiting: #url"
  q.add ->
    status.text "uploading: #url"
    upload-url url
  .then ->
    status.text "done: #url"

handle-paste = (event) ->
  event.preventDefault!
  event.clipboardData.getData \text .split \\n
  .forEach handle-url

if params.account_username
  list-albums!then ({data: albums}) ->
    $ \#album .empty!prepend albums.map ({title, id}) ->
      $ \<option> .text title .attr \value id

document.querySelector \#urls .addEventListener \paste handle-paste
