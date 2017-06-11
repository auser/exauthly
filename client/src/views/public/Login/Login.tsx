import * as React from "react";
import * as classnames from "classnames";

import { Link } from "react-router-dom";

import "./Login.scss";
import CenterLayout from "../../../layouts/CenterLayout";
import styled from "styled-components";

import LoginForm from "./components/LoginForm";

const HomeView = props =>
  <div className={classnames("login", props.className)}>
    <div className="container text-center">
      <div className="panel">
        <div className="panel-heading">
          <Link to="/">
            <h1>Login</h1>
          </Link>
        </div>
        <div className="panel-body">
          <div className="row">
            <div className="col-xs-12">
              <LoginForm />
            </div>
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
