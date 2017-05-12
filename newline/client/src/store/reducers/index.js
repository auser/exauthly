import { combineReducers } from 'redux'
import application, * as appSelectors from './application'
import auth, * as authSelectors from './auth'

const rootReducer = combineReducers({
  application,
  auth,
})

export default rootReducer