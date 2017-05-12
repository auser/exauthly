import React, {Component} from 'react'
import T from 'prop-types'
import {connect} from 'react-redux'
import { Form, TextField, SubmitField } from 'react-components-form';
import Schema from 'form-schema-validation';

import {loginRequest} from '../../store/actions'

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
    let {dispatch} = this.props
    let {formState, currentlySending, error} = this.props.data

    return (
      <div className='form-page__wrapper'>
        <div className='form-page__form-wrapper'>
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
            <SubmitField value="Submit" />
          </Form>
        </div>
      </div>
    )
  }

  _login (email, password) {
    this.props.dispatch(loginRequest({email, password}))
  }
}

Login.propTypes = {
  data: T.object,
  history: T.object,
  dispatch: T.func
}

export default connect(
  (state) => ({ data: state.auth })
)(Login)