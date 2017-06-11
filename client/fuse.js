const {
  FuseBox,
  Sparky,
  SVGPlugin,
  CSSPlugin,
  CSSResourcePlugin,
  BabelPlugin,
  JSONPlugin,
  UglifyJSPlugin,
  SassPlugin,
  WebIndexPlugin,
  EnvPlugin
} = require('fuse-box')
const rimraf = require('rimraf')
const fs = require('fs')
const path = require('path')
const express = require('express')

const isProduction = process.env.NODE_ENV === 'production'
const dist = path.resolve(__dirname, './dist')



const env = {
  BACKEND: process.env.BACKEND || 'http://localhost:4000/graphql'
}

/**
 * Fuse options
 */
const fuse = new FuseBox({
  homeDir: 'src/',
  sourceMaps: !isProduction,
  output: 'dist/$name.js',
  log: isProduction,
  hash: isProduction,
  cache: !isProduction,
  plugins: [
    WebIndexPlugin({
      title: 'exauthly',
      template: 'src/index.html'
    }),
    [SassPlugin(), CSSResourcePlugin(), CSSPlugin()],
    CSSPlugin({
      outFile: file => `${dist}/${file}`,
      inject: file => `${file}`
    }),
    BabelPlugin({}),
    JSONPlugin(),
    ...(isProduction
      ? [UglifyJSPlugin({ comments: false, mangle: true, drop_console: true })]
      : []),
    EnvPlugin(env)
  ]
})

/**
 * Task Runners
 */
Sparky.task(
  'remove-dist',
  () =>
    new Promise((resolve, reject) => {
      rimraf('dist/*.js', () =>
        rimraf('dist/*.js.map', () => rimraf('dist/styles/*', () => resolve()))
      )
    })
)

Sparky.task('favicon', () => Sparky.src('favicon.png').dest('dist/$name'))

Sparky.task('default', ['dev'], () => {})

Sparky.task('dev', [], () => {
  // fuse.dev({ port: 8080 });
  fuse.dev({ root: false, port: 8080 }, server => {
    const app = server.httpServer.app
    app.use('/', express.static(dist))
    app.get('*', function (req, res) {
      res.sendFile(path.join(dist, 'index.html'))
    })
    app.set('port', 8081)
    app.listen(8081)
  })
  fuse.bundle('app').watch().hmr().instructions('> index.jsx')
  fuse.run()
})

Sparky.task('build', ['remove-dist', 'favicon'], () => {
  fuse.bundle('vendor').instructions('~ index.jsx')
  fuse.bundle('app').instructions('!> [index.jsx]')
  fuse.run()
})
