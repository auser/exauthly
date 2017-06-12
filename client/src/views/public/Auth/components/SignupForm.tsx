import * as React from "react";
import * as classnames from "classnames";
import { connect } from 'react-redux'
import { graphql } from 'react-apollo'

import { Form, FormGroup, Submit } from "../../../../components/Form";
import { tryUserLogin } from '../../../../redux/modules/auth/actions'

import SIGNUP_MUTATION from '../../../../graphql/signup';

export class SignupForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      errors: []
    }
  }
  loginSubmit = fields => {
    this.props.trySignup(fields)
    .then(({ data }) => {
      const { login } = data;
      this.props.tryUserLogin(login)
    })
    .then(() => this.props.history.replace('/'))
    .catch(err => {
      this.setState({
        errors: err
      })
    })
  }

  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
        <FormGroup
          field={"name"}
          type="text"
          className="col-xs-12"
          label={"Your name"}
        />
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
          <Submit type="submit" value="Signup" className="col-xs-12" />
        </div>
      </Form>
    );
  }
}

const SignupFormWithMutation = graphql(SIGNUP_MUTATION, {
  options: {
    variables: {}
  },
  props: ({ ownProps, mutate }) => ({
    trySignup: (opts) => mutate({
      variables: opts
    })
  })
})(SignupForm)


export default connect(
  null,
  dispatch => ({
    tryUserLogin: (creds) => dispatch(tryUserLogin(creds))
  })
)(SignupFormWithMutation);
