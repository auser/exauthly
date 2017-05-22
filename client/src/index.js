import React from 'react'
import ReactDOM from 'react-dom'

import 'font-awesome/css/font-awesome.min.css'
import 'animate.css/animate.min.css'
import 'normalize.css/normalize.css'

import './index.css'
import './utils/polyfills'

import Root from './containers/Root'

const MOUNT = document.getElementById('root')
const render = NextApp => ReactDOM.render(<NextApp />, MOUNT)

if (module.hot) {
  module.hot.accept('./containers/Root', () => {
    render(require('./containers/Root').default)
  })
}

render(Root)