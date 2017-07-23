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
import Logout from './Auth/Logout/Logout';

// Accounts
import AccountProfile from './Account/Profile';
import AccountBilling from './Account/Billing';
import AccountOrgs from './Account/Organizations';

// import PublicRoutes from './public/routes'
// import ProtectedRoutes from './protected/routes'

export const Routes = props => {
  return (
    <Router {...props}>
      <Switch>
        {/* Public routes  */}
        <Route path="/about" component={About} />
        <Route exact path="/docs" component={Docs} />
        <Route exact path="/" component={Home} />

        {/* Auth routes  */}
        <Route path="/login" component={Login} />
        <Route path="/signup" component={Signup} />
        <Route path="/logout" component={Logout} />

        {/* Account routes  */}
        <Route path="/account/organizations" component={AccountOrgs} />
        <Route path="/account/billing" component={AccountBilling} />
        <Route path="/account" component={AccountProfile} />

        <Redirect to="/" />
      </Switch>
    </Router>
  );
};

export default Page(Routes);
