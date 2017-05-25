import gql from 'graphql-tag';

export default gql`
mutation localLogin($email:Email!,$password:String!) {
  localLogin(email:$email, password: $password) {
    token
  }
}
`