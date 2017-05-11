import { put, call } from 'redux-saga/effects'
import {
  appActions,
} from '../actions'

function* initialSetup() {
  try {
    yield put(appActions.initializeAppRequest())
    yield put(appActions.initializeApp())
  } catch (e) {
    yield put(appActions.initializeAppFailure())
    console.error(`Initial setup failed: ${e.message}`)
  }
}

export default initialSetup