import * as React from "react";
import * as classnames from 'classnames'
import styled from 'styled-components'

export class Form extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      fields: {}
    }
  }

  _renderChildren = () => {
    return React.Children.map(this.props.children, c => {
      return React.cloneElement(c, {
        onChange: this.handleChange.bind(this),
        name: 'BOB'
      })
    })
  }

  handleChange = (field:string) => (value: string) => {
    const { fields } = this.state
    this.setState({
      fields: { ...fields, [field]: value }
    })
  }

  handleSubmit = evt => {
    evt.preventDefault()
    this.props.onSubmit && this.props.onSubmit(this.state.fields)
  }

  render() {
    return (
      <form role="form" onSubmit={this.handleSubmit}>
        {this._renderChildren()}
      </form>
    );
  }
}

export default Form
