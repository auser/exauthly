import * as React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom'

import Home from './Home/Home'
import Login from './Auth/Login/Login'
import Signup from './Auth/Signup/Signup'
import Forgot from './Auth/ForgotPassword/ForgotPassword'

export const Routes = (props:any) => {
  return (
    <div>
      <Route
        path="/login"
        render={renderProps => <Login {...renderProps} {...props} />} />
      <Route
        path="/signup"
        render={renderProps => <Signup {...renderProps} {...props} />} />
      <Route
        path="/forgot_password"
        render={renderProps => <Forgot {...renderProps} {...props} />} />
      <Route
        path="/" exact
        render={renderProps => <Home {...renderProps} {...props} />} />
    </div>
  )
}

export default Routes
