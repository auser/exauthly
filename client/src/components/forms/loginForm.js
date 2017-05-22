import React from 'react'
import { graphql } from 'react-apollo'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'

import { Form, TextField, SubmitField } from 'react-components-form';
import Schema from 'form-schema-validation';

import LOGIN_MUTATION from 'graphql/mutations/Login'

const loginSchema = new Schema({
  email:{
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true
  }
});

export const LoginForm = (props) => {
  
  const signin = ({ email, password }) => {
    props.mutate({
      variables: { email, password }
    }).then(({ data: { login: { token }} }) => {
      console.log(token)
    })
  }

  const handleError = (errors, data) => {
    console.log('error --->', errors)
  }

  return (
    <Form
      schema={loginSchema}
      onSubmit={signin}
      onError={handleError}
  >
      <TextField name="email" label="Email" type="text" />
      <TextField name="password" label="Password" type="password" />
      <SubmitField value="Submit" />
  </Form>
  )
}

const signInWithMutation = graphql(LOGIN_MUTATION)(LoginForm)
export default connect(s => s)(signInWithMutation)