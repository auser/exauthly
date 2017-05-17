import React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Switch
} from 'react-router-dom'
// import Route from 'components/AuthRoute'

import Dashboard from './Dashboard/Dashboard'
// import Home from './views/Home/Home'

export default props => (
  <Router>
    <Switch>
      <Route path="/dashboard" component={Dashboard} />
    </Switch>
  </Router>
)