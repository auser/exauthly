import { authTypes } from 'store/constants'
import storage from 'utils/localStorage'

export function changeForm (newFormState) {
  return {
    type: authTypes.CHANGE_FORM, 
    newFormState
  }
}

export function loginRequest (payload) {
  return {
    type: authTypes.LOGIN_REQUEST,
    payload
  }
}

export function successfulLogin (payload) {
  storage.saveAuthToken(payload.token)
  return {
    type: authTypes.ON_LOGIN_SUCCESS,
    payload
  }
}

export function logoutRequest () {
  storage.clearAuthToken()
  return {
    type: authTypes.ON_LOGOUT_SUCCESS
  }
}

export function errorLogin (payload) {
  return {
    type: authTypes.ON_LOGIN_ERROR,
    payload
  }
}