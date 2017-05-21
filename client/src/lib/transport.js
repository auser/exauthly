import { createNetworkInterface } from 'react-apollo'
import config from 'config';

// Returns either a standard, fetch-full-query network interface or a
// persisted query network interface (from `extractgql`) depending on
// the configuration within `./config.js.`
export default function getNetworkInterface(host = config.API_URL, headers = {}) {
  return createNetworkInterface({
    ssrMode: !process.browser,
    uri: `${host}/graphql`,
    opts: {
      credentials: 'same-origin',
      headers,
    },
  });
}