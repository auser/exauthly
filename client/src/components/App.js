import React from 'react'
import Routes from 'routes'
import './App.css'

import { connect } from 'react-redux'

function App(props) {
  return (
    <div id="app">
      <main>
        <Routes {...props} />
      </main>
    </div>
  )
}

export default connect(
  state => ({
    isLoggedIn: !!state.auth.token
  })
)(App)
