import * as React from "react";
import * as T from 'prop-types'
import styled from 'styled-components'

class InputField extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: ''
    }
  }

  handleChange = (evt:Event) => {
    evt.preventDefault()
    const val:string = evt.target.value;
    this.setState({
      value: val
    }, () => this.props.onChange(val))
  }

  render() {
    return (
      <input
        value={this.state.value}
        className={this.props.className}
        {...this.props}
        onChange={this.handleChange}
      />
    )
  }
}

export const Input = styled(InputField)`
  color: ${props => props.theme.dark};
  padding: 20px;
  font-size: 1.1em;
  background-color: ${props => props.theme.softYellow};
  border: 0;
  font-family: sans-serif;
`;

Input.propTypes = () => ({
  field: T.string.required,
  onChange: T.func.required,
})

export default Input
