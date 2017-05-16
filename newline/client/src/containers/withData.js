import React, { Component } from 'react'
import T from 'prop-types'

import {
  ApolloProvider, getDataFromTree
} from 'react-apollo'

import initApollo from '../lib/initApollo'
import configureStore from '../store'

export default ComposedComponent => {
  return class withData extends Component {
    static displayName = `WithData(${ComposedComponent.displayName})`
    static propTypes = {
      serverState: T.object.isRequired,
    }

    
  }
}