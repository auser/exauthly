import * as types from './constants'

const loadedToken = localStorage.getItem("token")
export const initialState = {
  authenticated: !!loadedToken,
  token: loadedToken,
  requesting: false,
}

export const reducer = function (state = initialState, action:any) {
  switch(action.type) {
    case types.USER_REQUESTING_LOGIN:
      return {
        ...state,
        requesting: true,
      }

    case types.USER_LOGGED_IN:
      return {
        ...state,
        authenticated: !!action.payload,
        token: action.payload,
        requesting: false,
      }

    case types.USER_LOGGED_OUT:
      return {
        ...state,
        authenticated: false,
        token: null,
        requesting: false,
      }

    default: {
      return state;
    }
}
