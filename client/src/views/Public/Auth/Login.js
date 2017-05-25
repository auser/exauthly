import React from 'react'

import withHeader from 'containers/withHeader'
import LoginForm from 'components/Forms/LoginForm'

import styles from './Login.css'

console.log(styles)

export class LoginView extends React.Component {
  render () {
    return (
      <div>
        <h2 className="">
          <div className="content">Login</div>
        </h2>
        <LoginForm />
      </div>
    )
  }
}

export default withHeader(LoginView)