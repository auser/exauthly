import * as React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom'

import Home from './Home/Home'
import Login from './Login/Login'

export const Routes = (props:any) => {
  return (
    <div>
      <Route
        path="/login"
        render={renderProps => <Login {...renderProps} {...props} />} />
      <Route
        path="/" exact
        render={renderProps => <Home {...renderProps} {...props} />} />
    </div>
  )
}

export default Routes
