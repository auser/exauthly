import * as React from 'react';
import * as classnames from 'classnames';
import {connect} from 'react-redux';

import gql from 'graphql-tag';
import {graphql} from 'react-apollo';

import {Form, LabelInput, Submit} from '../../../components/Form';

interface State {
  errors: string[];
}
interface Props {}

export class SignupForm extends React.Component<Props, State> {
  constructor(props) {
    super(props);

    this.state = {
      errors: []
    };
  }
  loginSubmit = fields => {
    this.props
      .createUser({variables: fields})
      .then(resp => {
        const {token} = resp.data.signupWithEmailAndPassword;
        console.log('resp --->', token);
      })
      .then(() => this.props.history.replace('/'))
      .catch(err => {
        this.setState({
          errors: err
        });
      });
  };

  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
        <LabelInput
          field={'name'}
          type="text"
          className="col-xs-12"
          label={'Your name'}
        />
        <LabelInput
          field={'email'}
          type="email"
          className="col-xs-12"
          label={'Email'}
        />
        <LabelInput
          field={'password'}
          type="password"
          className="col-xs-12"
          label={'Password'}
        />
        <div className="submit">
          <Submit type="submit" value="Signup" className="col-xs-12" />
        </div>
      </Form>
    );
  }
}

const signupMutation = gql`
  mutation createUser($email: Email!, $password: Password!, $name: String!) {
    signupWithEmailAndPassword(
      email: $email
      password: $password
      name: $name
    ) {
      token
    }
  }
`;

const SignupFormWithMutation = graphql(signupMutation, {
  name: 'createUser'
})(SignupForm);

export default SignupFormWithMutation;
