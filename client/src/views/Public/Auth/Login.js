import React from 'react'

import withHeader from 'containers/withHeader'
import LoginForm from 'components/forms/loginForm'

import styles from './Login.css'

console.log(styles)

export class LoginView extends React.Component {
  render () {
    return (
      <div>
        <div className="column">
          <h2 className="ui teal header">
            <div className="content">Login</div>
          </h2>
        </div>
        <LoginForm />
      </div>
    )
  }
}

export default withHeader(LoginView)