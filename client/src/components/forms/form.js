import React from 'react'
import T from 'prop-types'

import FormGroup from './formGroup'

export class Form extends React.Component {
  constructor(props) {
    super(props)

    this.state = this.props.fields
  }

  handleChange = field => evt => this.setState({[field]: evt.target.value})

  onSubmit = (evt) => {
    evt.preventDefault()
    this.props.onSubmit(this.state)
  }

  render() {
    const { title } = this.props
    return (
      <div>
        <form onSubmit={this.onSubmit}>
          <div className="form-group">
            <h3>{title}</h3>
          </div>
          <div className="form-group">
            <p className="text-danger">{this.state.error}</p>
          </div>

          {this.props.children}
           
          <input
            type="submit"
            className="btn btn-success"
            value={title} />
        </form>
      </div>
    )
  }
}

const signInWithMutation = graphql(LOGIN_MUTATION)(LoginForm)
export default connect(s => s)(signInWithMutation)