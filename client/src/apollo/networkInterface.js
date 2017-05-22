import 'isomorphic-fetch'
import storage from 'utils/localStorage'

import { createNetworkInterface } from 'react-apollo'
import config from 'config';

console.log(`${config.API_URL}/graphql`)

export default function getNetworkInterface(host = config.API_URL, headers = {}) {

  const networkInterface = createNetworkInterface({
    uri: `${host}/graphql`,
    opts: {
      credentials: 'same-origin',
      headers,
    },
  });

  networkInterface.use([{
    applyMiddleware(req, next) {
      if (!req.options.headers) {
        req.options.headers = {};
      }

      const token = storage.authToken();

      req.options.headers.authorization = token ? `Bearer ${ token }` : null;
      next();
    }
  }]);

  return networkInterface
}