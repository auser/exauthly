import React, {Component} from 'react'
import { graphql } from 'react-apollo';
import gql from 'graphql-tag'

import {
  Redirect
} from 'react-router-dom'
import T from 'prop-types'
import {connect} from 'react-redux'
import { Form, TextField, SubmitField } from 'react-components-form';
import ErrorMessage from 'components/common/ErrorMessage'
import Schema from 'form-schema-validation';

import { successfulLogin, errorLogin } from 'store/actions'

const loginSchema = new Schema({
  email: { type: String, required: true },
  password: { type: String, required: true }
})

class Login extends Component {
  constructor (props) {
    super(props)

    this._login = this._login.bind(this)
  }

  render () {
    const { auth } = this.props
    if (auth.loggedIn) {
      return <Redirect to="/dashboard" />
    }
    return (
      <div className='form-page__wrapper'>
        <div className='form-page__form-wrapper'>
          {auth.error && <ErrorMessage error={auth.error} />}
          <div className='form-page__form-header'>
            <h2 className='form-page__form-heading'>Login</h2>
          </div>
          <Form
            schema={loginSchema}
            onSubmit={this._login}
            onError={(errors, data) => console.log('error', errors, data)}
          >
            <TextField name="email" label="Email" type="text" />
            <TextField name="password" label="Password" type="password" />
            <SubmitField value="Submit" type="submit" />
          </Form>
        </div>
      </div>
    )
  }

  _login ({ email, password }) {
    console.log("_login")
    this.props.submitLogin({ email, password })
  }
}

Login.propTypes = {
  data: T.object,
  history: T.object,
  dispatch: T.func
}

const LOGIN_MUTATION = gql`
mutation login($email:String!, $password:String!){
  login(email:$email, password:$password){
    token
  }
}
`

const withMutations = graphql(LOGIN_MUTATION, {
  props: ({ ownProps, mutate }) => ({
    submitLogin: ({ email, password }) => mutate({
      variables: { email, password }
    }).then(({ data }) => {
      const { login } = data
      ownProps.onSuccessfulLogin(login)
    }).catch(ownProps.onErrorLogin)
  })
})

export default connect(
  (state) => ({ 
    data: state.auth,
    auth: state.auth,
  }),
  (dispatch) => ({
    onSuccessfulLogin(token) {
      dispatch(successfulLogin(token))
    },
    onErrorLogin (error) {
      dispatch(errorLogin(error))
    }
  })
)(withMutations(Login))