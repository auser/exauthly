import * as auth from './auth/reducer'

export const initialState = {
  auth: auth.initialState,
}

export const reducers = {
  auth: auth.reducer
}

