import * as React from "react";
import * as classnames from "classnames";

import styled from "../../../styles/styled-components";

export const ConnectAccount = (props:any) => {
  return (
    <div className={props.className}>
      <h2>here</h2>
      <a href="/auth/gumroad">Connect your Gumroad account</a>
    </div>
  )
}

export const ConnectAccountView = styled(ConnectAccount)`
background-color: ${props => props.theme.bg}
`;

export default ConnectAccountView;
