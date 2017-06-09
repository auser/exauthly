import React from 'react';
import ReactDOM from 'react-dom';
import { AppContainer } from 'react-hot-loader';
import { Provider } from 'react-redux';
import createHistory from 'history/createBrowserHistory';
import { browserHistory } from 'react-router';

import configureStore, { sagaMiddleware } from 'store';
import Root from 'config/Root';
import ComingSoon from 'config/ComingSoon'
import Sagas from 'sagas';

console.log('hello')

const store = configureStore(browserHistory);

sagaMiddleware.run(Sagas);

const history = createHistory();

const render = (Component) => {
  ReactDOM.render(
    <AppContainer>
      <Component />
    </AppContainer>,
    document.getElementById('root'),
  );
};

render(ComingSoon);

if (module.hot) {
  module.hot.accept('./config/ComingSoon', () => {
    const newApp = require('./config/ComingSoon').default;
    render(newApp);
  });
}
