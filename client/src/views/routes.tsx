import * as React from 'react';
import {BrowserRouter as Router, Switch, Route, Link} from 'react-router-dom';

import Page from '../hocs/page';

import Home from './Home/Home';
import About from './About/About';

// import PublicRoutes from './public/routes'
// import ProtectedRoutes from './protected/routes'

export const Routes = props => {
  return (
    <Router {...props}>
      <Switch>
        <Route path="/about" component={About} />
        <Route exact path="/" component={Home} />
      </Switch>
    </Router>
  );
};

export default Page(Routes);
