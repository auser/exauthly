import * as React from 'react';
import {Route, Redirect} from 'react-router-dom';

// import getViewer from "../graphql/getViewer";
import client from '../lib/apollo';
import auth from '../lib/auth';

export const withAuthentication = Wrapped => {
  const withAuthorization = (props: any) => {
    return <Wrapped {...props} />;
  };

  return withAuthorization;
};
