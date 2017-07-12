import * as React from "react";
import * as classnames from "classnames";

import { Link } from "react-router-dom";

import "../Auth.scss";
import CenterLayout from "../../../../layouts/CenterLayout";
import styled from "styled-components";

import ForgotPasswordForm from "../components/ForgotPasswordForm";

const HomeView = props =>
  <div
    className={classnames("forgot_password", "container", "text-center", props.className)}
  >
    <div className="col-xs-12 col-sm-8">
      <div className="panel">
        <div className="panel-heading">
          <Link to="/">
            <h1>Reset your password</h1>
          </Link>
        </div>
        <div className="panel-body">
          <div className="row text-center">
            <div className="col-xs-12">
              <ForgotPasswordForm />
            </div>
          </div>
        </div>
        <div className="panel-footer">
          <div className="row">
             <Link to="/login">Login</Link> | <Link to="/signup">Sign up</Link>
          </div>
        </div>
      </div>
    </div>
  </div>;

export const Home = CenterLayout(HomeView);

export default styled(Home)`
background-color: ${props => props.theme.blue};
border-color: rgb(104, 145, 162);
outline: 0;
`;
