import React from 'react'
import { ApolloProvider } from 'react-apollo';
// import { SubscriptionClient, addGraphQLSubscriptions } from 'subscriptions-transport-ws';

// Polyfill fetch
import 'isomorphic-fetch'
import storage from 'utils/localStorage'

import createApolloClient from 'lib/create-apollo-client'
import getNetworkInterface from 'lib/transport'
import config from 'config'

const API_URL = config.API_URL

import { configureStore } from '../store'
import App from './App'

const networkInterface = getNetworkInterface(API_URL);
networkInterface.use([{
  applyMiddleware(req, next) {
    if (!req.options.headers) {
      req.options.headers = {};  // Create the header object if needed.
    }
    // get the authentication token from local storage if it exists
    const token = storage.authToken();
    req.options.headers.authorization = token ? `Bearer ${token}` : null;
    next();
  }
}]);

const client = createApolloClient({
  networkInterface,
  initialState: window.__APOLLO_STATE__,
  ssrForceFetchDelay: 100,
  connectToDevTools: true,
})

const store = configureStore(client, {})

function Root(){
  return (
    <ApolloProvider client={client} store={store}>
      <App />
    </ApolloProvider>
  )
}
export default Root