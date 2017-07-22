import * as React from 'react';
import {Link} from 'react-router-dom';

export const AuthMenu = props =>
  <ul className="nav navbar-nav navbar-right">
    <li>
      <Link to="/account">Account</Link>
    </li>
    <li>
      <Link to="/logout">Logout</Link>
    </li>
  </ul>;

export default AuthMenu;
