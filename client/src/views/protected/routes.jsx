import React from 'react'
import {
  Route,
  Link
} from 'react-router-dom'

import Home from './Home/Home'

export const Routes = props => {
  return (
    <div>
      <Route
        path="/" exact
        render={renderProps => <Home {...renderProps} {...props} />} />
    </div>
  )
}

export default Routes
