import * as store from 'store'

const AUTH_TOKEN_KEY = 'token'

class Storage {
  constructor() {
  }

  authToken() {
    return localStorage.getItem(AUTH_TOKEN_KEY)
  }

  saveToken(value) {
    return localStorage.setItem(AUTH_TOKEN_KEY, value)
  }

  removeToken() {
    return localStorage.removeItem(AUTH_TOKEN_KEY)
  }
}

export default new Storage()
