import React from 'react'
import {
  BrowserRouter as Router,
  Redirect,
  Switch
} from 'react-router-dom'
import Route from './components/AuthRoute'

import PublicRoutes from 'views/Public/routes'
import PrivateRoutes from 'views/Private/routes'
// import Home from './views/Home/Home'

export default props => (
  <Router>
    <div>
      <pre>{JSON.stringify(props, null, 2)}</pre>
      <Switch>
        {props.isLoggedIn && <PrivateRoutes {...props} />}
        <PublicRoutes {...props} />
      </Switch>
      <Route path="*" component={() => <Redirect to="/" />} />
    </div>
  </Router>
)