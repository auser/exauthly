import * as constants from './constants'

export const tryUserLogin = (user) => {
  localStorage.setItem("token", user.token)
  return {
    type: constants.USER_LOGGED_IN,
    payload: user
  }
}

export const userLogout = () => {
  localStorage.removeItem("token")
  return {
    type: constants.USER_LOGGED_OUT
  }
}
