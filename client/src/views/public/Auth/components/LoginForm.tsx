import * as React from "react";
import * as classnames from "classnames";

import { Form, FormGroup, Submit } from "../../../../components/Form";
import { graphql } from 'react-apollo'

import LOGIN_MUTATION from '../../../../graphql/login';

export class LoginForm extends React.Component {
  loginSubmit = fields =>
    this.props.tryLogin(fields)
    .then((user) => {
      console.log('USER!', user)
    })
    .catch(err => {
      console.log('login error', err)
    })
  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
          <FormGroup
            field={"email"}
            type="email"
            className="col-xs-12"
            label={"Email"}
          />
        <FormGroup
          field={"password"}
          type="password"
          className="col-xs-12"
          label={"Password"}
        />
        <div className="submit">
          <Submit type="submit" value="Login" className="col-xs-12" />
        </div>
      </Form>
    );
  }
}


const LoginFormWithMutation = graphql(LOGIN_MUTATION, {
  options: {
    variables: {}
  },
  props: ({ ownProps, mutate }) => ({
    tryLogin: (opts) => mutate({
      variables: opts
    })
  })
})(LoginForm)


export default LoginFormWithMutation;
