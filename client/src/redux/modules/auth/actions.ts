import * as constants from './constants'
import storage from '../../../lib/storage'

export const tryUserLogin = (user) => {
  storage.saveToken(user.token);
  return {
    type: constants.USER_LOGGED_IN,
    payload: user
  }
}

export const userLogout = () => {
  storage.removeToken()
  return {
    type: constants.USER_LOGGED_OUT
  }
}
