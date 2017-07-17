import * as React from 'react';
import * as classnames from 'classnames';
import {graphql} from 'react-apollo';

import SOCIAL_LOGIN_MUTATION from '../../../graphql/social_login';

export class SocialLogin extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      msg: ''
    };
  }

  componentDidMount() {}

  componentWillUnmount() {}

  // handleClick = provider => () => {
  //   hello(provider).login({
  //   }).then(({network, authResponse}) => {
  //     const { uid } = authResponse
  //     this.props.socialLogin({
  //       uid: uid,
  //       provider: network,
  //     })
  //     .then(({ data }) => {
  //       const { socialLogin } = data;
  //       this.props.tryLogin(socialLogin)
  //     })
  //     .then(() => this.props.history.replace('/'))
  //     .catch(err => {
  //       console.warn(err)
  //     })
  //   })
  // }

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
            <a href="/auth/github" className="btn btn-primary">
              Github
            </a>
          </div>
          <div className="col-xs-4">Signup with Gumroad</div>
          <div className="col-xs-4">Signup with Google</div>
        </div>
      </div>
    );
  }
}

export default graphql(SOCIAL_LOGIN_MUTATION, {
  props: ({ownProps, mutate}) => ({
    socialLogin: opts =>
      mutate({
        variables: opts
      })
  })
})(SocialLogin);
