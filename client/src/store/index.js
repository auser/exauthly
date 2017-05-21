import { createStore, applyMiddleware, combineReducers, compose } from 'redux'

import { createLogger } from 'redux-logger'
// import createSagaMiddleware from 'redux-saga'
import rootReducer from './reducers'
// import sagas from './sagas'

let reduxStore = null

export function create(apollo, initialState = {}) {
  // const sagaMiddleware = createSagaMiddleware()
  let middlewares = [apollo.middleware()]
  let composeEnhancers = compose

  if (process.env.NODE_ENV !== 'production') {
    const logger = createLogger({
      predicate: (getState, action) => (
        action.type !== '@@router/LOCATION_CHANGE'
      )
    })
    middlewares = [ ...middlewares, logger ]
    composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
  }

  const store = createStore(
    combineReducers({
      ...rootReducer,
      apollo: apollo.reducer(),
    }),
    initialState,
    composeEnhancers(
      applyMiddleware(...middlewares)
    )
  )

  // sagaMiddleware.run(sagas)

  /* Hot reloading of reducers.  How futuristic!! */
  if (module.hot) {
  module.hot.accept('./reducers', () => {
    /*eslint-disable */ // Allow require
    const nextRootReducer = require('./reducers').default;
    /*eslint-enable */
    store.replaceReducer(nextRootReducer);
  });
}


  return store
}

export function configureStore(apollo, initialState) {
  if (!process.browser) return create(apollo, initialState);
  if (!reduxStore) {
    reduxStore = create(apollo, initialState)
  }
  return reduxStore
}

export default configureStore