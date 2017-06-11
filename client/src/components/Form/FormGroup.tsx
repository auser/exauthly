import * as React from "react";
import * as classnames from "classnames";
import styled from "styled-components";

import Input from "./Input";
import Label from "./Label";

export class FormGroup extends React.Component {
  onChange = field => value => {};

  render() {
    const {
      className,
      label,
      placeholder,
      type = "text",
      field,
      onChange = this.onChange,
      ...rest
    } = this.props;

    return (
      <div className={"row"}>
        <div className={classnames("form-group", className)}>
          <Label>{label}</Label>
          <Input
            type={type}
            id="inputEmail"
            className="login_box"
            placeholder={placeholder || label}
            onChange={onChange(field)}
            {...rest}
          />
        </div>
      </div>
    );
  }
}

export default styled(FormGroup)`
display: flex;
flex-direction: column;
`;
