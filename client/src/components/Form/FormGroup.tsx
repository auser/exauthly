import * as React from 'react';
import * as T from 'prop-types';
import * as classnames from 'classnames';
import styled from 'styled-components';

import Input from './Input';
import Label from './Label';

export interface FormGroupState {
  fieldState: string;
  empty: boolean;
}

export interface FormGroupProps {
  inputClassName?: string;
  className?: string;
  label?: string;
  placeholder?: string;
  type: string;
  field: string;
  onChange?: Function;
  valid?: Boolean;
  displayLabel?: Boolean;
  required?: Boolean;
  children?: any;
}

export class FormGroup extends React.Component<FormGroupProps, FormGroupState> {
  static contextTypes = {
    form: T.object.isRequired
  };

  _renderDefault() {
    const {
      inputClassName,
      className,
      label,
      placeholder,
      type = 'text',
      field,
      onChange = this.context.form.onChange,
      valid,
      displayLabel = true,
      ...rest
    } = this.props;

    return (
      <div>
        {displayLabel &&
          label &&
          <Label>
            {label}
          </Label>}
        <Input
          type={type}
          id="inputEmail"
          className={classnames('form-group', inputClassName)}
          placeholder={placeholder || label}
          onChange={onChange(field)}
          {...rest}
        />
      </div>
    );
  }
  render() {
    const {className, children} = this.props;

    return (
      <div className={classnames('form-group', className)}>
        {children ? children : this._renderDefault()}
      </div>
    );
  }
}

export default styled(FormGroup)`
// display: flex;
// flex-direction: column;
`;
