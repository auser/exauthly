import { combineReducers } from 'redux'
import application, * as appSelectors from './application'

const rootReducer = combineReducers({
  application,
})

export default rootReducer