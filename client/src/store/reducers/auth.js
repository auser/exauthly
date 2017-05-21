// import { combineReducers } from 'redux'
import { authTypes } from 'store/constants'
import storage from 'utils/localStorage'

export default login

const token = storage.authToken()
const initialState = {
  error: '',
  currentlySending: false,
  loggedIn: !!token,
  token
}


function login(state = initialState, action) {
  switch (action.type) {
    case authTypes.LOGIN_REQUEST:
      return {
        ...state,
        error: '',
        currentlySending: true,
      }
    case authTypes.ON_LOGIN_SUCCESS:
      return {
        ...state,
        error: '',
        currentlySending: false,
        loggedIn: true,
        token: action.payload
      }
    case authTypes.ON_LOGIN_ERROR:
      return {
        ...state,
        currentlySending: false,
        error: action.payload && action.payload.message,
        loggedIn: false,
        token: null,
      }
    default:
      return state
  }
}
