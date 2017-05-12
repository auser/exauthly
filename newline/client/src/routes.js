import React from 'react'
import {
  BrowserRouter as Router,
  Redirect,
  Switch
} from 'react-router-dom'
import { AuthRoute as Route } from './components/AuthRoute'

import Landing from './views/Landing/Landing'
import Login from './views/Auth/Login'

export default props => (
  <Router>
    <Switch>
      <Route path="/login" component={Login} />
      <Route exact path="/" component={Landing} />
      <Route path="*" component={() => <Redirect to="/" />} />
    </Switch>
  </Router>
)