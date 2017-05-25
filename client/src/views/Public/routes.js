import React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Redirect,
  Switch
} from 'react-router-dom'
// import Route from 'components/AuthRoute'

import Landing from './Landing/Landing'
import Login from './Auth/Login'

// import Home from './views/Home/Home'

export default props => (
  <Router>
    <Switch>
      <Route path="/login" component={Login} />
      <Route exact path="/" component={Landing} />
      {/*<Route path="*" component={() => <Redirect to="/" />} />*/}
    </Switch>
  </Router>
)