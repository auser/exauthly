import React from 'react'
import propTypes from 'proptypes'
import { connect } from 'react-redux'

import {
  Redirect,
  Route
} from 'react-router-dom'

const LOGIN_ROOT = '/login'
const PRIVATE_ROOT = '/'

export const AuthRoute = ({ component, loggedIn, ...props }) => {
  const { isPrivate } = component

  if (loggedIn) {
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

export default connect(
  state => ({
    auth: state.auth,
    loggedIn: state.auth.loggedIn
  })
)(AuthRoute)