import { put, call } from 'redux-saga/effects'
import { authTypes } from '../constants'
import {
  authActions,
} from '../actions'

function* requestLogin(action) {
  try {}
  catch (e) {}
}


export function* watchFormChangeRequest() {
  yield takeLatest(authTypes.CHANGE_FORM)
}

export function* watchLoginRequest() {
  yield takeLatest(authTypes.LOGIN_REQUEST, requestLogin)
}

export default {
  watchFormChangeRequest
}