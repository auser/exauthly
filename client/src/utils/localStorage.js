import store from 'store'

export const AUTH_TOKEN_KEY = 'AUTH_TOKEN_KEY'

// Import plugins here
// see
// https://www.npmjs.com/package/store

export class Storage {
  authToken() { return store.get(AUTH_TOKEN_KEY) }
  saveAuthToken(val) { return store.set(AUTH_TOKEN_KEY, val); }
  clearAuthToken() { return store.remove(AUTH_TOKEN_KEY); }
}

export default new Storage()