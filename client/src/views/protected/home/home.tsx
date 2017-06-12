import * as React from "react";
import * as classnames from "classnames";

import CoreLayout from "../../../layouts/CoreLayout";
import styled from "styled-components";

import GumroadAccount from "./components/gumroad_account/gumroad_account";
import Products from "./components/products/products";

const HomeView = ({ me, className, ...rest }) =>
  <div>
    <div className={classnames("container", className)}>
      <div className="container">
        <div className="row">
          <div className="col-xs-12 col-sm-4">
            {`Welcome back ${me && me.name}`}
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 col-sm-4">
            {me && me.gumroadId
              ? <Products getViewer={me} {...rest} />
              : <GumroadAccount getViewer={me} {...rest} />}
          </div>
        </div>
      </div>
    </div>
  </div>;

export const Home = styled(CoreLayout(HomeView))`
`;

export default Home;
