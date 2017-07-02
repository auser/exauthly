import * as React from "react";
import * as classnames from "classnames";
import { connect } from 'react-redux'
import { graphql } from 'react-apollo'

import { Form, FormGroup, Submit } from "../../../../components/Form";
import { tryUserLogin } from '../../../../redux/modules/auth/actions'

import SocialLogin from './SocialLogin'

import LOGIN_MUTATION from '../../../../graphql/login';
import hello from '../../../../lib/hello'

export class LoginForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      errors: []
    }
  }
  loginSubmit = fields =>
    this.props.tryLogin(fields)
    .then(({ data }) => {
      const { login } = data;
      this.props.tryUserLogin(login)
    })
    .then(() => this.props.history.replace('/'))
    .catch(err => {
      this.setState({
        errors: err.graphQLErrors
      })
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
        <div>
          {this.state.errors && this.state.errors.map(err => (
            <div key={err.message}>{err.message}</div>
          ))}
        </div>
        <SocialLogin
          tryLogin={this.props.tryUserLogin}
          history={this.props.history}
        />
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

export default connect(
  null,
  dispatch => ({
    tryUserLogin: (creds) => dispatch(tryUserLogin(creds))
  })
)(LoginFormWithMutation);
