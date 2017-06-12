import * as store from 'store'

const AUTH_TOKEN_KEY = 'token'

class Storage {
  constructor() {
  }

  authToken() {
    return store.get(AUTH_TOKEN_KEY)
  }

  saveToken(value) {
    return store.set(AUTH_TOKEN_KEY, value)
  }

  removeToken() {
    return store.remove(AUTH_TOKEN_KEY)
  }
}

export default new Storage()
