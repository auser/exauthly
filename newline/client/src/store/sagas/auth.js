import { put, call } from 'redux-saga/effects'
import { authTypes } from '../constants'
import {
  authActions,
} from '../actions'

export function* watchFormChangeRequest() {
  yield takeLatest(authTypes.CHANGE_FORM)
}

export default {
  watchLoginRequest
}