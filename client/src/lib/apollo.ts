import ApolloClient, { createNetworkInterface } from 'apollo-client';

import Storage from './storage'

const networkInterface = createNetworkInterface({
  uri: process.env.BACKEND
})

networkInterface.use([{
  applyMiddleware(req, next) {
    if (!req.options.headers) {
      req.options.headers = {};  // Create the header object if needed.
    }
    if (Storage.authToken()) {
      req.options.headers.Authorization = `Bearer ${Storage.authToken()}`;
    }
    next();
  },
}]);

const client = new ApolloClient({
  networkInterface,
});

export default client;
