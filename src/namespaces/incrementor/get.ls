require! {
  'when': wn
}

module.exports = (params, cookie) ->
  wn.promise (resolve, reject) ->
    engino.auth.getUserByToken(cookie.token)
    .then (result) ->
      if result.success
        userId = result.user._id
        engino.mongo.collection('products').find({ userId }).toArray!.then (data) ->
          if data.length is 0
            engino.mongo.collection('products').insert({number: 0, userId }).then ->
              console.log "products collection created for user #{userId}"
              resolve 0
          else
            resolve data.0.number
      else
        resolve 0