import * as React from 'react';
import * as classnames from 'classnames';
import {graphql} from 'react-apollo';

import {Link} from 'react-router-dom';

import './Login.scss';
import CenterLayout from '../../../layouts/CenterLayout';
import styled from 'styled-components';
import LOGIN_MUTATION from '../../../graphql/login';

import auth from '../../../lib/auth';

import LoginForm from '../components/LoginForm';
import SocialLogin from '../components/SocialLogin';

const LoginView = props => {
  const handleSubmit = resp => {
    auth.login(resp.token);
    props.history.replace('/');
  };
  return (
    <div
      className={classnames(
        'login',
        'container',
        'text-center',
        props.className
      )}
    >
      <div className="col-xs-12 col-sm-8">
        <div className="panel">
          <div className="panel-heading">
            <Link to="/">
              <h1>Login</h1>
            </Link>
          </div>
          <div className="panel-body">
            <div className="row text-center">
              <div className="col-xs-12">
                <LoginForm onSubmit={handleSubmit} {...props} />
              </div>
              <div className="col-xs-12">
                {/* <SocialLogin {...props} /> */}
              </div>
            </div>
          </div>
          <div className="panel-footer">
            <div className="row">
              <Link to="/signup">Sign up</Link> |{' '}
              <Link to="/forgot_password">Forgot password</Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export const Login = CenterLayout(LoginView);

export default styled(Login)`
background-color: ${props => props.theme.softGrey};
border-color: ${props => props.theme.blue};
outline: 0;
border-radius: 5px;
`;
