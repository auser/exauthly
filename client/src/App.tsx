import * as React from "react";
import * as ReactDOM from "react-dom";
// import { ApolloProvider } from 'react-apollo';

import './styles/main.scss'

if (process.env.NODE_ENV !== "production") {
  // If in development mode make sure the entire page reloads anytime there is a change. In the
  // future this can be fine-tuned by just having stateful modules reload the entire page.
  // const { setStatefulModules } = require('fuse-box/modules/fuse-hmr')
  // setStatefulModules((page) => {
  // console.log(page)
  // });
}

import Routes from "./views/routes";
import { ThemeProvider } from "styled-components";
import theme from "./styles/theme";

// import client from './lib/apollo'
// import configureStore from './lib/redux_store'

// const store = configureStore(client, {})

/**
 * Render application into a div
 */
export const render = element => {
  // require("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css");
  // our app
  // require("./styles/main.scss");
  ReactDOM.render(
    <ThemeProvider theme={theme}>
      <Routes />
    </ThemeProvider>,
    document.querySelector(element)
  );
};
// import { setStatefulModules } from './hmr';
// setStatefulModules('hmr', 'store/', 'actions/');
