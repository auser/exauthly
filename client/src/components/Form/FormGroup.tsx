import * as React from "react";
import * as classnames from 'classnames'
import styled from 'styled-components'

import Input from './Input'
import Label from './Label'

export class FormGroup extends React.Component {
  onChange = evt => {
    console.log(evt.target.value);
  };
  render() {
    const {
      className, label,
      placeholder
    } = this.props

    return (
      <div className={classnames("form-group", className)}>
        <Label>{label}</Label>
        <Input
          type="text"
          id="inputEmail"
          className="login_box"
          placeholder={placeholder || label}
          required
          autoFocus
        />

      </div>
    );
  }
}

export default styled(FormGroup)`
display: flex;
flex-direction: column;
`;
