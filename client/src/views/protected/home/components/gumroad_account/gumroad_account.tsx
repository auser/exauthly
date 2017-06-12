import * as React from "react";
import * as classnames from "classnames";

import styled from "styled-components";

export const GumroadAccount = (props:any) => {
  return (
    <div className={props.className}>
      <a href={`/auth/gumroad?state=${props.getViewer && props.getViewer.id}`}>Connect your Gumroad account</a>
    </div>
  )
}

export const ConnectAccountView = styled(GumroadAccount)`
`;

export default ConnectAccountView;
