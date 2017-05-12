import { ApolloClient } from 'react-apollo'

export default opts => new ApolloClient(Object.assign({}, {
  addTypename: true,
  dataIdFromObject: res => {
    if (res.id && res.__typename) {
      return res.__typename + res.id;
    }
    return null
  },
}, opts))