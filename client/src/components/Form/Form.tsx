import * as React from 'react';
import * as T from 'prop-types';
// import * as classnames from 'classnames';
// import styled from 'styled-components';

interface Props {
  children: any;
  canSubmit?: Function;
  onSubmit: Function;
  initialValues?: any;
}

interface State {
  fields: any;
  valid: Boolean;
}

export class Form extends React.Component<Props, State> {
  static childContextTypes = {
    form: T.object
  };

  state = {
    fields: {},
    valid: false
  };

  constructor(props) {
    super(props);

    this.state = {
      fields: props.initialValues || {},
      valid: this.canSubmit({})
    };
  }

  getChildContext() {
    return {
      form: {
        onChange: this.handleChange.bind(this),
        valid: this.canSubmit(this.state.fields),
        fields: this.state.fields
      }
    };
  }

  handleChange = (field: string) => (value: string) => {
    const {fields} = this.state;
    this.setState(
      {
        fields: {...fields, [field]: value}
      },
      () => {
        this.setState({
          valid: this.canSubmit(this.state.fields)
        });
      }
    );
  };

  canSubmit = (fields: any) => {
    return typeof this.props.canSubmit === 'function'
      ? this.props.canSubmit(fields)
      : true;
  };

  handleSubmit = (evt: Event) => {
    evt.preventDefault();
    this.props.onSubmit && this.props.onSubmit(this.state.fields);
  };

  render() {
    return (
      <form role="form" onSubmit={this.handleSubmit.bind(this)}>
        {this.props.children}
      </form>
    );
  }
}

export default Form;
