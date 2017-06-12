import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';

import * as modules from '../redux/modules';

const enhancer = process.env.NODE_ENV === 'development' ? composeWithDevTools : compose

export const configureStore = (client, initialState) => {

  const state = {
    ...initialState,
    ...modules.initialState
  }

  const middleware = applyMiddleware(
    client.middleware()
  )
  const reduxStore = createStore(
    combineReducers({
      apollo: client.reducer(),
      ...modules.reducers
    }),
    state, // initial state
    enhancer(middleware)
  );

  if (module.hot) {
    module.hot.accept('../redux/modules', () => {
      const modules = require('../redux/modules')
      reduxStore.replaceReducer(combineReducers({
        apollo: client.reducer(),
        ...modules.reducers
      }))
    })
  }

  return reduxStore;
};

export default configureStore;
