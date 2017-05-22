import React, { Component } from 'react'
import T from 'prop-types'

// Polyfill
import 'isomorphic-fetch'

import ApolloClient from 'apollo-client'

import { ApolloProvider } from 'react-apollo'

import { configureStore } from '../store'
import Routes from 'routes'

import networkInterface from '../apollo/networkInterface'

const client = new ApolloClient({
  networkInterface: networkInterface(),
  addTypename: true,
  initialState: window.__APOLLO_STATE__,
  ssrForceFetchDelay: 100,
  connectToDevTools: true,
})

const store = configureStore(client, {})

export const Root = props => (
  <ApolloProvider client={client} store={store}>
    <Routes {...props} />
  </ApolloProvider>
)

export default Root