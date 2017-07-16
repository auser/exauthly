import * as React from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  Redirect
} from 'react-router-dom';

import Page from '../hocs/page';

import Home from './Home/Home';
import About from './About/About';
import Docs from './Docs/Docs';

// Auth routes
import Login from './Auth/Login/Login';
import Signup from './Auth/Signup/Signup';

// import PublicRoutes from './public/routes'
// import ProtectedRoutes from './protected/routes'

export const Routes = props => {
  return (
    <Router {...props}>
      <Switch>
        <Route path="/about" component={About} />
        <Route exact path="/docs" component={Docs} />
        <Route exact path="/" component={Home} />

        <Route path="/login" component={Login} />
        <Route path="/signup" component={Signup} />
        <Redirect to="/" />
      </Switch>
    </Router>
  );
};

export default Page(Routes);
