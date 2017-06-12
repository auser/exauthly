import * as React from 'react'
import {
  BrowserRouter as Router,
  Route,
  Link,
  Redirect,
} from 'react-router-dom'

import GET_VIEWER_QUERY from '../../graphql/getViewer'
import { graphql } from 'react-apollo'

import Home from './home/home'
import Logout from './auth/logout'

export const Routes = (props:any) => {
  return (
    <div>
      <Route
        path="/logout"
        render={renderProps => <Logout />} />
      <Route
        path="/" exact
        render={renderProps => <Home {...renderProps} {...props} />} />
      <Route
        path="*"
        render={() => <Redirect to="/" />} />
    </div>
  )
}

export default graphql(GET_VIEWER_QUERY, {
    options: { fetchPolicy: 'force' },
    props: ({ data: { loading, me } }) => ({
    loading, me,
  }),
})(Routes)
