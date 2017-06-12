import * as React from "react";
import * as classnames from "classnames";

import { Link } from "react-router-dom";

import "./Signup.scss";
import CenterLayout from "../../../../layouts/CenterLayout";
import styled from "styled-components";

import SignupForm from "../components/SignupForm";

const HomeView = props =>
  <div
    className={classnames("signup", "container", "text-center", props.className)}
  >
    <div className="col-xs-12 col-sm-8">
      <div className="panel">
        <div className="panel-heading">
          <Link to="/">
            <h1>Signup</h1>
          </Link>
        </div>
        <div className="panel-body">
          <div className="row text-center">
            <div className="col-xs-12">
              <SignupForm />
            </div>
          </div>
        </div>
        <div className="panel-footer">
          <div className="row">
            <Link to="/login">Login</Link> | <Link to="/forgot_password">Forgot password</Link>
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
