const AUTH_KEY = 'auth-key';

import Storage from './storage';

export class Auth {
  login(token) {
    Storage.saveToken(token);
  }

  logout() {
    Storage.removeToken();
  }

  isAuthenticated() {
    return !!Storage.authToken();
  }
}

export default new Auth();
