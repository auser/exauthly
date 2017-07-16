import * as React from 'react';
import * as classnames from 'classnames';

import gql from 'graphql-tag';
import {graphql} from 'react-apollo';

import {Form, LabelInput, Submit} from '../../../components/Form';

// import SocialLogin from './SocialLogin';

interface State {
  errors: string[];
}
interface Props {}

export class LoginForm extends React.Component<Props, State> {
  constructor(props) {
    super(props);

    this.state = {
      errors: []
    };
  }
  loginSubmit = fields => {
    this.props
      .login({variables: fields})
      .then(resp => {
        console.log(resp);
      })
      .catch(err => {
        this.setState({
          errors: [err]
        });
      });
  };

  render() {
    return (
      <Form onSubmit={this.loginSubmit}>
        <LabelInput field={'email'} type="email" label={'Email'} />
        <LabelInput field={'password'} type="password" label={'Password'} />

        <div className="submit">
          <Submit type="submit" value="Login" className="col-xs-12" />
        </div>
        <div>
          {this.state.errors &&
            this.state.errors.map(err =>
              <div key={err.message}>
                {err.message}
              </div>
            )}
        </div>
      </Form>
    );
  }
}

const loginMutation = gql`
  mutation login($email: Email!, $password: String!) {
    login(email: $email, password: $password) {
      token
      id
      email
    }
  }
`;

const LoginFormWithMutation = graphql(loginMutation, {name: 'login'})(
  LoginForm
);

export default LoginFormWithMutation;
