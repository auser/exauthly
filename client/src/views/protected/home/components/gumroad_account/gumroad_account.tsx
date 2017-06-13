import * as React from "react";
import * as classnames from "classnames";
import * as hello from 'hellojs'

import styled from "styled-components";

const OAuth2Settings = {
  version: 2,
  auth: 'https://api.gumroad.com/oauth/authorize',
  grant: 'https://api.gumroad.com/oauth/token',
  response_type: 'code',
  redirect_uri: 'http://localhost:8080/index.html'
};

hello.init({
  gumroad: {
    name: 'gumroad',
    oauth: OAuth2Settings,
    base: 'https://api.gumroad.com/v2',
  }
}, {
  oauth_proxy: 'http://localhost:4000/auth/proxy'
})

export class GumroadAccount extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      open: false,
      user: []
    }
  }

  componentDidMount() {
    hello.init({
      gumroad: process.env.GUMROAD_CLIENT_ID,
    }, {
    })
  }

  handleClick = (evt) => {
    evt.preventDefault()
    const { getViewer } = this.props
    hello('gumroad').login({
      scope: 'basic',
      state: {
        user_id: getViewer.id
      }
    }).then(({network, authResponse}) => {
      console.log(authResponse)
    })

    hello.on('auth.login', {}, ({ network, authResponse }) => {
      console.log('auth login ->', authResponse)
    })

    hello.on('error', {}, (err) => {
      console.warn("ERROR", err)
    })
  }

  render() {
    const { className, getViewer } = this.props
    return (
      <div className={className}>
        <div onClick={this.handleClick}>Connect your Gumroad account</div>
      </div>
    )
  }
}

export const ConnectAccountView = styled(GumroadAccount)`
`;

export default ConnectAccountView;
