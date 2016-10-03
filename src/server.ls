require! {
  'when': wn
  'express'
  'http'
  'socket.io'
  'cookieparser'
  '$engino/starter': enginoStarter
  '$engino/init': enginoInit
}

global.engino = {}

enginoInit.then (result) ->
  console.log 'Engino Core Modules: \n', result.enginoCore.keys!
  console.log 'Engino Namespaces: \n', result.enginoNamespaces.keys!
  enginoStarter(result.enginoCore, \mongo)
  .then (db) ->
    global.engino.mongo = db
  ns = require.context './namespaces', yes, /\.ls$/
  console.log 'Engino Current Application Namespaces: \n', ns.keys!

  app = express()
  server = http.createServer app
  io = socket server
  io.on 'connection', (socket) ->
    socket.emit \message,
      title: '-- Hello Dude --'

    socket.on \callee, (data) ->
      requestKey = data.requestKey or "invalid_key"
      try
        cookie = cookieparser.parse socket.request.headers.cookie
        (enginoStarter ns, data.fn) data.params, cookie
        .then (result) ->
          socket.send { requestKey, result }
        .catch (error) ->
          console.log error
          result = { success: false, msg: "Wrong Function Call" }
          socket.send { requestKey, result }
      catch error
        # TODO: use error handler to store log file in server
        # TODO: use pretty-error to show error in server console
        console.log error
        result = { success: false, msg: "Calling Error" }
        socket.send { requestKey, result }

  server.listen 3000, ->
    console.log 'Socket-Rest Server is online over port 3000'
