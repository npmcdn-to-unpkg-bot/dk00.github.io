## Imgur URL List Uploader / Playground

Paste a URLs to upload images.

Functions are exported to global so that you can play it in console.

### `window.imgur()`
Read token and user name from URL hash, returns a imgur object.

### `imgur.call(endpoint | {endpoint[, data]})`

Sends a request:
`GET https://api.imgur.com/3/${endpoint}`
with the token and returns a promise that resolves to parsed result.

If optional `data` is specified, sends the request with it by `POST` instead.

### `imgur.listAlbums()`

Alias for `imgur.call('account/${username}/albums')`,
returns album list for current user.

### `imgur.upload(image)`
* `image`: URL of the image.

Alias for

    imgur.call({
      endpoint: 'image',
      data: {image, album: $('album').val()}
    })
, uploads specified image to selected album.
