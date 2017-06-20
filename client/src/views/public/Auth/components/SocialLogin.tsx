import * as React from "react";
import * as classnames from "classnames";
import { graphql } from 'react-apollo'

import SOCIAL_LOGIN_MUTATION from '../../../../graphql/social_login';
import hello from '../../../../lib/hello'

export class SocialLogin extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      msg: ''
    }
  }

  componentDidMount() {
    hello.on('auth', (evt) => {
      console.log(evt)
      if (evt.error) {
        this.setState({
          msg: evt.error.message
        })
      } else {
        // this.props.tryLogin(evt)
        // .then(() => this.props.history.replace('/'))
      }
    })
  }

  componentWillUnmount() {
    if (hello) {
      hello.off('auth')
    }
  }

  handleClick = provider => () => {
    hello(provider).login({
    }).then(({network, authResponse}) => {
      const { social_account_id } = authResponse
      this.props.socialLogin({
        social_account_id: social_account_id,
        social_account_name: network,
      })
      .then(({ data }) => {
        const { socialLogin } = data;
        this.props.tryLogin(socialLogin)
      })
      .then(() => this.props.history.replace('/'))
      .catch(err => {
        console.warn(err)
      })
    })
  }

  render() {
    return (
      <div className="panel">
        <div className="row">
          <div className="col-xs-12 text-center">
            {this.state.msg}
            <hr />
          </div>
        </div>
        <div className="row">
          <div className="col-xs-4">
            <div
              onClick={this.handleClick('github')}
              className="btn btn-primary">
              Github
            </div>
          </div>
          <div className="col-xs-4">
            Signup with Gumroad
          </div>
          <div className="col-xs-4">
            Signup with Google
          </div>
        </div>
      </div>
    );
  }
}

export default graphql(SOCIAL_LOGIN_MUTATION, {
  props: ({ ownProps, mutate }) => ({
    socialLogin: (opts) => mutate({
      variables: opts
    })
  })
})(SocialLogin)
