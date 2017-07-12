import * as React from 'react';
import * as classnames from 'classnames';
import * as T from 'prop-types';
import styled from 'styled-components';

interface InputFieldProps {
  valid?: Boolean;
  onChange: Function;
  initialValue?: string;
  className: string;
  type: string;
  placeholder: string;
}

interface InputFieldState {
  value: string;
  focusState: string;
  empty: boolean;
}

class InputField extends React.Component<InputFieldProps, InputFieldState> {
  constructor(props: any) {
    super(props);

    this.state = {
      focusState: '',
      value: this.props.initialValue || '',
      empty: (this.props.initialValue || '').length === 0
    };
  }

  handleChange = (evt: Event) => {
    const val: string = evt.target.value;
    this.setState(
      {
        value: val,
        empty: val.length === 0
      },
      () => this.props.onChange(val)
    );
  };

  onBlur = (e: Event) => this.setState({focusState: 'blurred'});
  onFocus = (e: Event) => this.setState({focusState: 'focused'});

  render() {
    const {valid, type = 'text', initialValue, ...rest} = this.props;
    const {empty, value, focusState} = this.state;
    return (
      <input
        value={value}
        type={type}
        {...rest}
        className={classnames(this.props.className, focusState, {
          'is-empty': empty
        })}
        onChange={this.handleChange}
        onBlur={this.onBlur}
        onFocus={this.onFocus}
      />
    );
  }
}

export const Input = styled(InputField)`
  font-weight: 300;
  color: ${props => props.theme.dark};
  cursor: text;
  outline: none;
  border: 0;
  display: block;
  width: 100%;
  line-height: 32px;
  padding-bottom: 3px;
  transition: opacity 200ms ease-in-out;
  &::placeholder {
    color: #8898aa;
  }
  &.is-empty:not(.focused) {
    opacity: 0;
  }
`;

Input.propTypes = () => ({
  field: T.string.isRequired,
  onChange: T.func.isRequired,
  initialValue: T.string,
  submittable: T.bool
});

export default Input;
