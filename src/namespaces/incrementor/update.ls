require! {
  'when': wn
}

module.exports = (params, cookie) ->
  wn.promise (resolve, reject) ->
    engino.auth.getUserByToken(cookie.token)
    .then (result) ->
      if result.success
        userId = result.user._id
        if params.inc?
          engino.mongo
          .collection \products
          .update { userId }, {$inc: {number: 1}}
          .then ->
            resolve {success: true}
      else
        resolve {success: false}