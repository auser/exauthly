import * as React from 'react';
import {Redirect} from 'react-router-dom';
import auth from '../../../lib/auth';

interface Props {}

export const Logout: React.SFC<Props> = () => {
  auth.logout();
  return <Redirect to="/" />;
};

export default Logout;
