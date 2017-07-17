import gql from 'graphql-tag';

export default gql`
  mutation socialLogin($uid: String!, $provider: String!) {
    socialLogin(uid: $uid, provider: $provider) {
      token
      id
      email
    }
  }
`;
