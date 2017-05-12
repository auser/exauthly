import { authTypes } from '../constants'

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