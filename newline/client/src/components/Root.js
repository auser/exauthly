import React from 'react'
import { ApolloProvider } from 'react-apollo';
// import { SubscriptionClient, addGraphQLSubscriptions } from 'subscriptions-transport-ws';

// Polyfill fetch
import 'isomorphic-fetch'

import createApolloClient from 'lib/create-apollo-client'
import getNetworkInterface from 'lib/transport'
import config from 'config'

const API_URL = config.API_URL

import { configureStore } from '../store'
import App from './App'

const client = createApolloClient({
  networkInterface: getNetworkInterface(API_URL),
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