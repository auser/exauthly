import React from 'react'
import {
  BrowserRouter as Router,
  Redirect,
  Switch,

  Route,
} from 'react-router-dom'
// import Route from './components/AuthRoute'

import PublicRoutes from 'views/Public/routes'
// import PrivateRoutes from 'views/Private/routes'
// import Home from './views/Home/Home'

export default props => (
  <Router>
    <div>
      <Switch>
        {/*<Route path='/' component={() => <h2>Home</h2>} />*/}
        {/*{props.isLoggedIn && <PrivateRoutes {...props} />}*/}
        <PublicRoutes {...props} />
      </Switch>
      <Route path="*" component={() => <Redirect to="/" />} />
    </div>
  </Router>
)