import React from 'react'
import {
  BrowserRouter as Router,
  Switch,
  Route
} from 'react-router-dom'

import Landing from './views/Landing/Landing'
import Login from './views/Auth/Login'

export default props => (
  <Router>
    <Switch>
      <Route
        path="/login" component={Login} />
      <Route
        path="/" component={Landing} />
    </Switch>
  </Router>
)