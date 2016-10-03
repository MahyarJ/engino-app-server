require! {
  '@mahyarj/engino-server/webpackConfig'
}

config = webpackConfig do
  projectDir: __dirname
  index: './src/server.ls'

module.exports = config
