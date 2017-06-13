import * as React from "react";
import * as classnames from "classnames";

import hello from '../../../../../lib/hello'
import styled from "styled-components";

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
