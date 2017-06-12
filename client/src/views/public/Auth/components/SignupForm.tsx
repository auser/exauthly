import * as React from "react";
import * as classnames from "classnames";
import { graphql } from 'react-apollo'

import { Form, FormGroup, Submit } from "../../../../components/Form";

import SIGNUP_MUTATION from '../../../../graphql/signup';

export class SignupForm extends React.Component {
  loginSubmit = fields => this.props.trySignup(fields)

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


export default SignupFormWithMutation;
