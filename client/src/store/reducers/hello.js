import { combineReducers } from 'redux'
import types from 'store/constants'

const initialState = false

function hello(state = initialState, action) {
  switch (action.type) {
    case types.hello.SAY_HELLO:
      return true
    default:
      return state
  }
}

export default combineReducers({
  hello
})
