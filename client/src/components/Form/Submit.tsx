import * as React from "react";
import styled from 'styled-components'

const SubmitBtn = props => (
  <input
    type='submit'
    className={props.className}
    {...props}
  />
)

export const Submit = styled(SubmitBtn)`
border: 0;
background-color: ${props => props.theme.blue};
padding: 10px;
font-size: 1.1em;
`;

export default Submit
