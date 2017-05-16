import { ApolloClient } from 'react-apollo';

export default options => new ApolloClient(Object.assign({}, {
  addTypename: true,
  dataIdFromObject: (result) => {
    if (result.id && result.__typename) { // eslint-disable-line no-underscore-dangle
      return result.__typename + result.id; // eslint-disable-line no-underscore-dangle
    }
    return null;
  },
  // shouldBatch: true,
}, options));