import * as React from "react";
import { Route, Redirect } from "react-router-dom";
import { connect } from "react-redux";

// import getViewer from "../graphql/getViewer";
import client from "../lib/apollo";

export const withAuthentication = Wrapped => {
  const withAuthorization = (props: any) => {
    return <Wrapped {...props} />;
  };

  return connect(state => ({
    isAuthenticated: state.auth.authenticated
  }))(withAuthorization);
};

