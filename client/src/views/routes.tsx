import * as React from "react";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";

// import Page from '../hocs/page'

import PublicRoutes from './public/routes'
// import ProtectedRoutes from './protected/routes'

export const Routes = props => {
  return (
    <Router {...props}>
      <div>
        <Route
          render={renderProps => <PublicRoutes {...renderProps} {...props} />}
        />
        {/*
        props.isAuthenticated ?
          <Route render={renderProps => <ProtectedRoutes {...renderProps} {...props} />} />
          :
          <Route
          render={renderProps => <PublicRoutes {...renderProps} {...props} />} />
      */}
      </div>
    </Router>
  );
};

export default Routes;
