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
}

export default new Storage()
