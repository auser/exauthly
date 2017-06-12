import * as React from "react";
import * as classnames from "classnames";
import styled from "styled-components";

import Header from "../components/header/Header";

const Wrapper = styled.div`
display: flex;
align-items: center;
justify-content: center;
height: 100vh;
`;

const CenterLayout = Wrapped => props => {
  return (
    <Wrapper className={classnames("", props.className)}>
      <Wrapped {...props} />
    </Wrapper>
  );
};

export default CenterLayout;
