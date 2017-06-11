import * as React from "react";
import * as T from 'prop-types'
import styled from 'styled-components'

class InputField extends React.Component {
  render() {
    return (
      <input
        className={this.props.className}
        {...this.props}
      />
    )
  }
}

export const Input = styled(InputField)`
  color: ${props => props.theme.dark};
  padding: 20px;
  font-size: 1.5em;
  background-color: ${props => props.theme.softYellow};
  border: 0;
  font-family: sans-serif;
`;

Input.propTypes = () => ({
  field: T.string.required
})

export default Input
