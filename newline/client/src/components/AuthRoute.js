import React from 'react'
import propTypes from 'proptypes'

import {
  Redirect,
  Route
} from 'react-router-dom'

const isAuthenticated = () => false

const LOGIN_ROOT = '/login'
const PRIVATE_ROOT = '/home'

export const AuthRoute = ({ component, ...props }) => {
  const { isPrivate } = component

  if (isAuthenticated()) {
    // Authenticated user
    if (isPrivate === true) {
      return <Route {...props} component={component} />
    } else {
      return <Redirect to={ PRIVATE_ROOT } />
    }
  } else {
    if (isPrivate === true) {
      return <Redirect to={LOGIN_ROOT} />
    } else {
      return <Route {...props} component={component} />
    }
  }
}

AuthRoute.propTypes = {
  component: propTypes.oneOfType([propTypes.element, propTypes.func])
}

export default AuthRoute