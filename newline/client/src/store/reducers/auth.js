import { combineReducers } from 'redux'
import { authTypes } from '../constants'

export default login

const initialState = {
  formState: {
    email: '',
    password: '',
  },
  error: '',
  currentlySending: false,
  loggedIn: false,
}


function login(state = initialState, action) {
  switch (action.type) {
    case authTypes.CHANGE_FORM:
      return {
        ...state,
        formState: action.newFormState
      }
    case authTypes.LOGIN_REQUEST:
      return {
        ...state,
        error: '',
        currentlySending: true,
      }
    default:
      return state
  }
}
