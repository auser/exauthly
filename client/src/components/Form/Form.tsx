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
        onChange: this.handleChange.bind(this)
      })
    })
  }

  handleChange = (field:string, value: string) => {
    console.log('field', field, value)
  }

  handleSubmit = evt => {
    evt.preventDefault()
    console.log('handling submit')
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
