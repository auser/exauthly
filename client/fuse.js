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
const src = rel => path.resolve(__dirname, 'src', rel)

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
  alias: {
    'components': src('components'),
    'hoc': src('hocs'),
    'layouts': src('layouts'),
    'styles': src('styles')
  },
  plugins: [
    WebIndexPlugin({
      template: "src/index.html",
      title: "Fullstack edu",
    }),
    [SassPlugin(), CSSResourcePlugin(), CSSPlugin()],
    CSSPlugin({
      outFile: file => `${dist}/${file}`,
      inject: file => `${file}`
    }),
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

// Sparky.task('favicon', () => Sparky.src('favicon.png').dest('dist/$name'))

Sparky.task('default', ['dev'], () => {})

Sparky.task('dev', ['remove-dist'], () => {
  // fuse.dev({ port: 8080 });
  fuse.dev({ port: 8080 }, server => {
    const app = server.httpServer.app
    app.use('/', express.static(dist))
    app.get('*', function (req, res) {
      res.sendFile(path.join(dist, 'index.html'))
    })
    app.set('port', 8081)
    app.listen(8081)
  })
  fuse.bundle('public/js/app')
    .watch().hmr()
    .instructions('> index.tsx')
  fuse.run()
})

Sparky.task('build', ['remove-dist'], () => {
  fuse.bundle('public/js/vendor').instructions('~ index.jsx')
  fuse.bundle('public/js/app').instructions('!> [index.jsx]')
  fuse.run()
})
