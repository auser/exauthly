import * as React from "react";
import styled from 'styled-components'

export const Label = styled.label`
  color: ${props => props.theme.softBlue};
  padding: 3px;
  font-size: 1.1em;
  font-family: sans-serif;
  margin: 0;
  text-transform: uppercase;
  flex-direction: column;
  display: flex;
`;

export default Label
