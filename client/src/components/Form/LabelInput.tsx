import * as React from 'react';
import * as classnames from 'classnames';
import * as T from 'prop-types';
import styled from 'styled-components';

import {FormGroupProps, FormGroupState} from './FormGroup';
import Input from './Input';

export class LabelInput extends React.Component<
  FormGroupProps,
  FormGroupState
> {
  static contextTypes = {
    form: T.object.isRequired
  };

  render() {
    const {
      inputClassName = '',
      className,
      label,
      placeholder,
      type = 'text',
      field,
      initialValue = this.context.form.fields[this.props.field],
      onChange = this.context.form.onChange(this.props.field),
      valid,
      displayLabel = true,
      ...rest
    } = this.props;

    return (
      <label className={classnames(className)}>
        <Input
          type={type}
          initialValue={initialValue}
          className={classnames('field', inputClassName)}
          placeholder={placeholder || label}
          onBlur={this.onBlur}
          onFocus={this.onFocus}
          onChange={onChange}
          {...rest}
        />
        <span>
          <span>
            {label}
          </span>
        </span>
      </label>
    );
  }
}

export default styled(LabelInput)`
    height: 35px;
    position: relative;
    color: #8798ab;
    display: block;
    margin-top: 30px;
    margin-bottom: 20px;
    input {
    }
    > span {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      font-weight: 300;
      line-height: 32px;
      color: #8798ab;
      border-bottom: 1px solid #586a82;
      transition: border-bottom-color 200ms ease-in-out;
      cursor: text;
      pointer-events: none;
      span {
        position: absolute;
        top: 0;
        left: 0;
        transform-origin: 0% 50%;
        transition: transform 200ms ease-in-out;
        cursor: text;
      }
    }
    .field {
      &.focused + span span,
      &:not(.is-empty) + span span {
        transform: scale(0.68) translateY(-36px);
        cursor: default;
      }
      &.focused + span {
        border-bottom-color: ${props => props.theme.green};
      }
    }

  .field {
    background: transparent;
    font-weight: 300;
    border: 0;
    color: black;
    outline: none;
    cursor: text;
    display: block;
    width: 100%;
    line-height: 32px;
    padding-bottom: 3px;
    transition: opacity 200ms ease-in-out;
    &::-webkit-input-placeholder,
    &::-moz-placeholder {
      color: #8898aa;
    }
    &:-ms-input-placeholder {
      color: #424770;
    }
    &.is-empty:not(.is-focused) {
      opacity: 0;
    }
  }
`;
